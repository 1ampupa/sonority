import asyncio
import logging
import flet as ft

from pathlib import Path
from flet import Page
from tinytag import TinyTag

from module.core.songs.song_player import SongPlayer
from module.core.songs.songs_manager import SongManager

from module.gui.utils import GuiUtils

Logger: logging.Logger = logging.getLogger(__name__)

class GuiSongsList:

    @classmethod
    async def song_list(cls, page: Page) -> None:
        GuiUtils.create_default_page(page)

        # Page Elements
        title_text: ft.Text = ft.Text(value="YOUR SONG",size=60,font_family="Anton")
        song_list_box: ft.Column = ft.Column(scroll=ft.ScrollMode.ALWAYS)

        async def load_song(e):
            if SongPlayer.current_song is not None:
                try:
                    await SongPlayer.current_song.release()
                except Exception:
                    Logger.warning("Failed to release the current song.")
                    pass

            try:
                async def _execute_play(e):
                    song = SongPlayer(e.control.data["path"])
                    await asyncio.sleep(0.1)
                    await song.play()

                await asyncio.wait_for(_execute_play(e), timeout=1.0)
            except asyncio.TimeoutError:
                Logger.error("Can't play this song, took too long to load.")
            except Exception as e:
                Logger.error(f"Can't play this song due to {e}")

        def get_song_list(e=None):
            song_list_box.controls.clear()

            songs: list[Path] = SongManager.query_all_songs()

            for index, song in enumerate(songs):
                metadata = TinyTag.get(song.absolute())

                song_title = metadata.title if metadata.title is not None else song.stem

                song_list_box.controls.append(
                    ft.Column(
                        controls=[
                            ft.TextButton(
                                content=f"{index+1}: {song_title}",
                                data={"path": song.absolute()},
                                on_click=load_song
                            )
                        ],
                        expand=True
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
