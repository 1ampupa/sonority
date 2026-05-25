import flet as ft
import logging

from pathlib import Path
from flet import Page
from module.core.songs.songs_manager import SongManager
from module.gui.utils import GuiUtils

logger: logging.Logger = logging.getLogger(__name__)

class GuiSongsList:

    @classmethod
    def song_list(cls, page: Page) -> None:
        GuiUtils.create_default_page(page)

        # Page Elements
        title_text: ft.Text = ft.Text(value="YOUR SONG",size=60,font_family="Anton")
        song_list_box: ft.Column = ft.Column(scroll=ft.ScrollMode.ALWAYS)

        def get_song_data(e):
            logger.info(e.control.data["path"])

        def get_song_list(e=None):
            song_list_box.controls.clear()

            songs: list[Path] = SongManager.query_all_songs()

            for index, song in enumerate(songs):
                song_list_box.controls.append(
                    ft.TextButton(
                        content=f"{index+1}: {song.stem}",
                        data={"path": song.absolute()},
                        on_click=get_song_data
                    )
                )
            
            song_list_box.update()

        refresh_button: ft.Button = ft.Button(
            content="Refresh", icon=ft.Icons.REFRESH_ROUNDED, on_click=get_song_list,
            align=ft.Alignment.CENTER_RIGHT,
            expand=True
        )
        
        page.add(
            ft.Row(
                controls=[
                    title_text,
                    refresh_button
                ]
            ),
            ft.Divider(height=20),
            song_list_box
        )

        get_song_list()
