import flet as ft
import flet_audio as fta
import logging, asyncio

from pathlib import Path
from flet import Page
from flet_audio import Audio, ReleaseMode

from module.core.songs.songs_manager import SongManager

from module.gui.utils import GuiUtils

Logger: logging.Logger = logging.getLogger(__name__)

class GuiSongsList:

    song_player: Audio

    @classmethod
    def create_song_player(cls, song: Path) -> Audio:
        song_player: Audio = Audio(
            src=str(song),
            autoplay=False,
            volume=0.1,
            balance=0,
            release_mode=fta.ReleaseMode.STOP,
            on_loaded=lambda _: Logger.info(f"Loaded {str(song)}"),
        )
        return song_player

    @classmethod
    async def song_list(cls, page: Page) -> None:
        GuiUtils.create_default_page(page)

        # Page Elements
        title_text: ft.Text = ft.Text(value="YOUR SONG",size=60,font_family="Anton")
        song_list_box: ft.Column = ft.Column(scroll=ft.ScrollMode.ALWAYS)

        async def load(e):
            try: await cls.song_player.release()
            except Exception: pass
            cls.song_player = GuiSongsList.create_song_player(e.control.data["path"])
            page.services.append(cls.song_player)
            page.update()
            await asyncio.sleep(0.1)
            await cls.song_player.play()

        async def pause():
            await cls.song_player.pause()

        async def resume():
            await cls.song_player.resume()

        def get_song_list(e=None):
            song_list_box.controls.clear()

            songs: list[Path] = SongManager.query_all_songs()

            for index, song in enumerate(songs):
                song_list_box.controls.append(
                    ft.TextButton(
                        content=f"{index+1}: {song.stem}",
                        data={"path": song.absolute()},
                        on_click=load
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
