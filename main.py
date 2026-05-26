import logging
import flet as ft

from module.gui.utils import GuiUtils
from module.gui.songs_list_gui import GuiSongsList
from module.core.songs.songs_manager import SongManager

# Logger

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] (%(name)s) %(message)s",
    handlers=[logging.StreamHandler()] # prints to console
)

Logger = logging.getLogger("app.main")

Logger.info(SongManager.query_all_songs())

ft.run(main=GuiSongsList.song_list)
