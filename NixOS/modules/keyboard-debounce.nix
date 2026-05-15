# Software debounce for chattering keyboard switches.
# Grabs the physical keyboard, re-emits filtered events via uinput,
# dropping keydowns that arrive within `thresholdMs` of the same key's last keyup.
{ config, lib, pkgs, ... }:

let
  cfg = config.services.keyboardDebounce;

  debounceScript = pkgs.writers.writePython3Bin "kb-debounce" {
    libraries = [ pkgs.python3Packages.evdev ];
    flakeIgnore = [ "E401" "E501" "W503" "E266" "E402" ];
  } ''
    import sys
    import argparse
    import evdev
    from evdev import ecodes, UInput

    ap = argparse.ArgumentParser()
    ap.add_argument("--name", required=True)
    ap.add_argument("--threshold", type=int, default=40)
    args = ap.parse_args()

    threshold = args.threshold / 1000.0

    dev = None
    for path in evdev.list_devices():
        d = evdev.InputDevice(path)
        if d.name == args.name:
            dev = d
            break
    if dev is None:
        print(f"keyboard not found: {args.name!r}", file=sys.stderr)
        sys.exit(1)

    print(f"debouncing {dev.name} at {dev.path}, threshold={args.threshold}ms", flush=True)

    ui = UInput.from_device(dev, name=f"{dev.name} (debounced)")
    dev.grab()

    last_up = {}
    for ev in dev.read_loop():
        if ev.type == ecodes.EV_KEY:
            if ev.value == 1:  # keydown
                t = last_up.get(ev.code)
                if t is not None and (ev.timestamp() - t) < threshold:
                    continue  # drop chatter
            elif ev.value == 0:  # keyup
                last_up[ev.code] = ev.timestamp()
        ui.write_event(ev)
        ui.syn()
  '';
in
{
  options.services.keyboardDebounce = {
    enable = lib.mkEnableOption "evdev chatter filter";
    devices = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Exact evdev device name (see /proc/bus/input/devices `N: Name=...`).";
          };
          thresholdMs = lib.mkOption {
            type = lib.types.int;
            default = 40;
            description = "Drop keydowns arriving within this many ms of the same key's last keyup.";
          };
        };
      });
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = lib.listToAttrs (lib.imap0 (i: d:
      lib.nameValuePair "kb-debounce-${toString i}" {
        description = "Keyboard chatter filter (${d.name})";
        wantedBy = [ "multi-user.target" ];
        before = [ "display-manager.service" "getty@tty1.service" ];
        after = [ "systemd-udev-settle.service" ];
        serviceConfig = {
          ExecStart = "${debounceScript}/bin/kb-debounce --name ${lib.escapeShellArg d.name} --threshold ${toString d.thresholdMs}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      }
    ) cfg.devices);
  };
}
