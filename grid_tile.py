from PIL import Image, ImageDraw

def generate_grid_tile(filename, size, grid_spacing):
    """
    Generates a high-resolution base tile with a grid pattern.
    """
    # Base floor color (a neutral gray)
    base_color = (120, 120, 125)
    img = Image.new('RGB', size, color=base_color)
    draw = ImageDraw.Draw(img)

    # Line color for the tile joints (darker gray)
    line_color = (60, 60, 65)
    line_thickness = 4

    # Draw vertical lines
    for x in range(0, size[0], grid_spacing):
        draw.line([(x, 0), (x, size[1])], fill=line_color, width=line_thickness)
        
    # Draw horizontal lines
    for y in range(0, size[1], grid_spacing):
        draw.line([(0, y), (size[0], y)], fill=line_color, width=line_thickness)

    # Save the output
    img.save(filename)
    print(f"Success: {filename} generated at {size[0]}x{size[1]}")

if __name__ == "__main__":
    # Keeping the high-resolution requirement
    TILE_SIZE = (1024, 1024)
    TILE_SPACING = 256 # Creates a 4x4 grid within the tile
    
    generate_grid_tile("floor_tile.png", TILE_SIZE, TILE_SPACING)
