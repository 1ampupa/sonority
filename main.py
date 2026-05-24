import flet as ft

def main(page: ft.Page):
    page.title = "Sonority"
    page.theme_mode = ft.ThemeMode.SYSTEM

    page.window.width = 800
    page.window.height = 600
    page.window.resizable = False
    page.window.maximizable = False
    page.window.alignment = ft.Alignment.CENTER

    page.fonts = {
        "IBM Plex": "assets/fonts/IBMPlexSansThai-Regular.ttf",
        "Anton": "assets/fonts/Anton-Regular.ttf"
    }

    page.theme = ft.Theme(font_family="IBM Plex")
    page.update()

    page.add(
        ft.Container(
            content=ft.Column(
                controls=[
                    ft.Text(
                        value="SONORITY", 
                        size=40, 
                        font_family="Anton"
                    ),
                    ft.Text(
                        value="ยินดีต้อนรับสู่แอปเล่นเพลงที่ไม่มีโฆษณา 4 ตัวติด 😭", 
                        size=16
                    ),
                    ft.Text(
                        value="Sonority 2026, Made with Flet, Powered by yt-dlp library.", 
                        size=16,
                    ),
                ],
                alignment=ft.MainAxisAlignment.CENTER,
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            ),
            alignment=ft.Alignment.CENTER,
            expand=True
        )
    )

print("Hello world!")
ft.run(main=main)
