import math
import time
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

        async def load_song(e=None):
            if e is None: return
            if SongPlayer.current_song is not None:
                try:
                    await SongPlayer.current_song.release()
                except Exception:
                    pass

            try:
                async def _execute_play(e):
                    song = SongPlayer(e.control.data["path"])
                    await asyncio.sleep(0.25)
                    await song.play()

                await asyncio.wait_for(_execute_play(e), timeout=2.0)
            except asyncio.TimeoutError:
                Logger.error("Can't play this song, took too long to load.")
            except Exception as e:
                Logger.error(f"Can't play this song due to {e}")

        async def create_song_list(e=None):
            refresh_button.disabled = True
            song_list_box.controls.clear()
            page.update()

            await asyncio.sleep(0.1)

            start_time: float = time.perf_counter()

            songs: list[Path] = SongManager.query_all_songs()
            if len(songs) == 0:
                song_list_box.controls.append(
                    ft.Column(
                        controls=[
                            ft.Text(
                                value="Aw shucks...",
                                size=30,
                                weight=ft.FontWeight.BOLD,
                                align=ft.Alignment.CENTER
                            ),
                            ft.Text(
                                value="There's no song available.",
                                size=20,
                                weight=ft.FontWeight.BOLD,
                                align=ft.Alignment.CENTER
                            ),
                            ft.Text(
                                value="Try adding a music or look up in the search bar! (even if we haven't implement it yet 😭)",
                                size=16,
                                align=ft.Alignment.CENTER
                            )
                        ],
                        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        expand=True
                    )
                )
                refresh_button.disabled = False
                page.update()
                return

            for index, song in enumerate(songs):
                try:
                    metadata = await asyncio.to_thread(TinyTag.get, song.absolute())

                    song_title = metadata.title if metadata.title is not None else song.stem
                    song_artist = metadata.artist if metadata.artist is not None else "Unknown"
                    song_duration = metadata.duration if metadata.duration is not None else 0

                    minute = math.floor(song_duration / 60)
                    second = math.floor(song_duration % 60)
                    if minute < 10: minute = f"0{minute}"
                    if second < 10: second = f"0{second}"

                    song_button = ft.ListTile(
                        autofocus=False,
                        leading=ft.Text(value=f"{index+1}",weight=ft.FontWeight.BOLD,size=16,text_align=ft.TextAlign.RIGHT),
                        title=f"{song_title}",
                        subtitle=f"{song_artist}",
                        subtitle_text_style=ft.TextStyle(color=ft.Colors.GREY_400),
                        trailing=ft.Text(value=f"{minute}:{second}",weight=ft.FontWeight.BOLD,size=16,text_align=ft.TextAlign.LEFT),
                        data={"path": song.absolute()},
                        on_click=load_song,
                        expand=1
                    )
                
                    song_list_box.controls.append(song_button)
                except Exception:
                    Logger.error(f"Failed to create a button for {song.stem}")
                    pass

                if (index + 1) % 5 == 0 or (index + 1) == len(songs):
                    song_list_box.update()

            time_elapsed: float = time.perf_counter() - start_time
            Logger.info(f"Successfully created {len(songs)} buttons for {len(songs)} songs, took {time_elapsed:.2f} seconds")
           
            refresh_button.disabled = False
            page.update()

        refresh_button: ft.Button = ft.Button(
            content="Refresh", icon=ft.Icons.REFRESH_ROUNDED, on_click=create_song_list,
            align=ft.Alignment.CENTER_RIGHT,
            expand=True
        )
        
        page.add(
            ft.SafeArea(
                content=ft.Column(
                    controls=[
                        ft.Row(
                            controls=[
                                title_text,
                                refresh_button
                            ]
                        ),
                        ft.Divider(height=20),
                        ft.ListView(
                            controls=[song_list_box],
                            expand=True,
                            scroll=ft.ScrollMode.AUTO
                        )
                    ]
                ),
                expand=True,
                minimum_padding = 15
            )
        )

        await create_song_list()
        await load_song()
