import sys
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")

from gi.repository import Adw, Gio, Gtk


class InconelApp(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id="dev.inconel.Inconel",
            flags=Gio.ApplicationFlags.DEFAULT_FLAGS,
        )

    def do_activate(self):
        win = Adw.ApplicationWindow(application=self, title="Inconel")
        win.set_default_size(960, 640)
        win.set_content(Gtk.Label(label="Inconel"))
        win.present()


def main() -> int:
    return InconelApp().run(sys.argv)


if __name__ == "__main__":
    raise SystemExit(main())
