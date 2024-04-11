import io
import cairosvg
from pathlib import Path
from PIL import Image

# Basic ANSI color codes and their approximate RGB values
ansi_colors = {
    (0, 0, 0): "\033[30m",       # Black
    (128, 0, 0): "\033[31m",    # Red
    (0, 128, 0): "\033[32m",    # Green
    (128, 128, 0): "\033[33m",  # Yellow
    (0, 0, 128): "\033[34m",    # Blue
    (128, 0, 128): "\033[35m",  # Magenta
    (0, 128, 128): "\033[36m",  # Cyan
    (192, 192, 192): "\033[37m",# White
    # Bright versions for some
    (128, 128, 128): "\033[90m",# Bright Black (Gray)
    (255, 0, 0): "\033[91m",    # Bright Red
    (0, 255, 0): "\033[92m",    # Bright Green
    (255, 255, 0): "\033[93m",  # Bright Yellow
    (0, 0, 255): "\033[94m",    # Bright Blue
    (255, 0, 255): "\033[95m",  # Bright Magenta
    (0, 255, 255): "\033[96m",  # Bright Cyan
    (255, 255, 255): "\033[97m",# Bright White
}

# ascii_chars = "@%#*+=-:. "  # Assuming darker to lighter
ascii_chars = " .:-=+*#%@"  # Assuming darker to lighter
ascii_chars = """$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/|()1{}[]?-_+~<>i!lI;:,"^`\'. """[::-1]


def brightness_to_ascii(brightness):
    # Normalize brightness to 0-255 if it's not already
    index = int((brightness / 255) * (len(ascii_chars) - 1))
    return ascii_chars[index]

# Function to calculate grayscale brightness from RGB
def rgb_to_grayscale(rgb):
    r, g, b = rgb[:3]  # Ignore alpha if present
    return 0.299 * r + 0.587 * g + 0.114 * b

# Updated function to find the closest ANSI color, now also returns brightness
def find_closest_ansi_color_and_brightness(rgb):
    grayscale = rgb_to_grayscale(rgb)
    closest_color = min(ansi_colors.keys(), key=lambda color: (color[0]-rgb[0])**2 + (color[1]-rgb[1])**2 + (color[2]-rgb[2])**2)
    return ansi_colors[closest_color], grayscale


def resize_image(image: Image.Image, width: int) -> Image.Image:
    current_width, current_height = image.size
    ratio = current_height / current_width
    height = int(ratio * width)
    resized_image = image.resize((width, height))
    resized_image.save("html/resized.png")
    return resized_image

def convert_ascii(image: Image.Image) -> list:
    source_width, source_height = image.size
    image.save("html/resized.png")
    rated_to_character_aspect_ratio = image.resize((source_width, int(source_height * 0.45)))
    ascii_list = []
    pixels = rated_to_character_aspect_ratio.getdata()
    width_index = 0
    line=[]
    for pixel in pixels:
        if width_index >= source_width:
            ascii_list.append(line.copy())
            line.clear()
            width_index = 0
        # color = (pixel[0], pixel[1], pixel[2])
        ansi_code, brightness = find_closest_ansi_color_and_brightness(pixel)
        ascii_char = brightness_to_ascii(brightness)
        line.append(ansi_code+ascii_char+"\033[0m")
        width_index += 1

    return ascii_list

def print_ascii(data: list) -> None:
    for line in data:
        string = "".join(line)
        print(string)

def print_ascii_to_string(data: list) -> str:
    result = ""
    for line in data:
        string = "".join(line)
        result = result + string + "\n"
    return result

def convert_file(file_path: str) -> None:
    svg_data = cairosvg.svg2png(url=file_path,output_width=130)

    # Load the PNG data into Pillow Image
    png_io = io.BytesIO(svg_data)
    image = Image.open(png_io)
    converted_data = convert_ascii(image)
    return print_ascii_to_string(converted_data)

def main() -> None:
    # Example usage with a pixel's RGB value

    svg_path = Path("html/frame5.svg")
    svg_data = cairosvg.svg2png(url="html/frame8.svg",output_width=130)

    # Load the PNG data into Pillow Image
    png_io = io.BytesIO(svg_data)
    image = Image.open(png_io)

    # resized = resize_image(image, 130)
    # converted_data = convert_ascii(resized)
    converted_data = convert_ascii(image)
    print_ascii(converted_data)

if __name__ == "__main__":
    main()
    # print(convert_file("html/frame7.svg"))