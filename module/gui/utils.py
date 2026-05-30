import flet as ft

from flet import Page

class GuiUtils:

    @staticmethod
    def create_default_page(page: Page, page_name: str="Sonority") -> None:
        page.title = page_name
        page.theme_mode = ft.ThemeMode.SYSTEM

        page.window.width = 1000
        page.window.height = 750
        page.window.min_width = 1000
        page.window.min_height = 750
        page.window.resizable = True
        page.window.maximizable = True
        page.window.alignment = ft.Alignment.CENTER

        page.fonts = {
            "IBM Plex": "assets/fonts/IBMPlexSansThai-Regular.ttf",
            "Anton": "assets/fonts/Anton-Regular.ttf"
        }

        app_colour: ft.ColorScheme = ft.ColorScheme(
            primary="#7D5EFF",
            secondary="#888888",
            surface="#151515",
            surface_container="#1F1F1F"
        )

        page.theme = ft.Theme(font_family="IBM Plex", color_scheme=app_colour)
        page.update()
