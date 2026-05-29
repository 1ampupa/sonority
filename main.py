import logging
import flet as ft

from module.gui.songs_list_gui import GuiSongsList

# Logger

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] (%(name)s) %(message)s",
    handlers=[logging.StreamHandler()] # prints to console
)

Logger = logging.getLogger("app.main")

ft.run(main=GuiSongsList.song_list)
