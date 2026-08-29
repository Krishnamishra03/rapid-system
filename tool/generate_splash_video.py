import os
import math
import numpy as np
import cv2
from PIL import Image

def generate_splash_video():
    width = 1080
    height = 1920
    fps = 30
    duration_sec = 7
    total_frames = fps * duration_sec # 210 frames

    logo_path = r'e:\smart\assets\images\app_logo.jpg'
    output_path = r'e:\smart\assets\video\splash_intro.mp4'

    # Load Logo
    logo_pil = Image.open(logo_path).convert("RGBA")
    logo_w, logo_h = logo_pil.size
    
    # Scale logo fit comfortably (around 650px wide)
    target_w = 680
    aspect = logo_h / logo_w
    target_h = int(target_w * aspect)
    logo_resized = logo_pil.resize((target_w, target_h), Image.Resampling.LANCZOS)
    
    # Create mask for smooth rounded corners and alpha
    mask_np = np.zeros((target_h, target_w), dtype=np.float32)
    cv2.ellipse(mask_np, (target_w//2, target_h//2), (target_w//2 - 5, target_h//2 - 5), 0, 0, 360, 1.0, -1)
    mask_np = cv2.GaussianBlur(mask_np, (15, 15), 0)

    logo_np = np.array(logo_resized, dtype=np.float32) # RGBA

    # Setup VideoWriter
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

    np.random.seed(42)

    # Random background particles
    num_particles = 60
    particles = []
    for _ in range(num_particles):
        particles.append({
            'x': np.random.uniform(100, width - 100),
            'y': np.random.uniform(200, height - 200),
            'size': np.random.uniform(2.5, 6.0),
            'speed': np.random.uniform(0.4, 1.2),
            'alpha': np.random.uniform(0.3, 0.8),
            'color': (248, 189, 56) if np.random.rand() > 0.7 else (216, 99, 37) # Blue or Gold accent in BGR
        })

    print("Generating 7-second cinematic intro video frames...")

    for f in range(total_frames):
        t = f / fps # Current time in seconds (0.0 to 7.0)

        # Base Deep Navy Background Canvas (#0A0E27 -> BGR: 39, 14, 10)
        canvas = np.zeros((height, width, 3), dtype=np.float32)
        
        # Create subtle radial gradient from center (#1E1B4B in center to #0A0E27 at edges)
        Y, X = np.ogrid[:height, :width]
        dist_from_center = np.sqrt((X - width/2)**2 + (Y - height/2)**2)
        max_dist = np.sqrt((width/2)**2 + (height/2)**2)
        norm_dist = np.clip(dist_from_center / max_dist, 0.0, 1.0)

        # Background color interpolation (Deep Navy + Electric Blue ambient)
        center_color = np.array([75, 27, 30], dtype=np.float32) # BGR
        edge_color = np.array([30, 10, 8], dtype=np.float32)
        bg_grad = center_color[None, None, :] * (1.0 - norm_dist[:, :, None]) + edge_color[None, None, :] * norm_dist[:, :, None]
        canvas += bg_grad

        # 0–2 sec: Center Blue Glow & Shield outline emerging
        glow_intensity = 0.0
        if t <= 2.0:
            glow_intensity = (t / 2.0)
        elif t <= 5.5:
            glow_intensity = 1.0 + 0.15 * math.sin((t - 2.0) * math.pi)
        elif t <= 7.0:
            glow_intensity = max(0.0, (7.0 - t) / 1.5)

        # Render Ambient Blue Glow Circle in center
        glow_radius = int(320 + 40 * math.sin(t * 2.0))
        glow_overlay = np.zeros((height, width, 3), dtype=np.float32)
        cv2.circle(glow_overlay, (width//2, height//2), glow_radius, (235, 99, 37), -1) # Electric blue BGR
        glow_overlay = cv2.GaussianBlur(glow_overlay, (181, 181), 0)
        canvas += glow_overlay * (glow_intensity * 0.45)

        # Render Faint GPS Grid Lines & Particles (4 - 6.5s)
        if t > 1.5 and t < 6.5:
            grid_alpha = min(1.0, (t - 1.5) / 1.0) if t < 4.0 else max(0.0, (6.5 - t) / 1.0)
            grid_alpha *= 0.25
            
            # Subtle animated GPS path line
            pts = np.array([[200, 1300], [450, 1150], [600, 1250], [880, 1050]], np.int32)
            cv2.polylines(canvas, [pts], False, (248, 189, 56), 2, cv2.LINE_AA)

        # Update and render particles
        for p in particles:
            p['y'] -= p['speed']
            if p['y'] < 0: p['y'] = height
            
            p_alpha = p['alpha'] * glow_intensity
            if p_alpha > 0.05:
                cv2.circle(canvas, (int(p['x']), int(p['y'])), int(p['size']), p['color'], -1)

        # 2–7 sec: Logo Appearance & Micro Scale
        logo_alpha = 0.0
        logo_scale = 1.0
        vertical_shift = 0

        if t < 1.0:
            logo_alpha = 0.0
        elif t <= 3.0:
            # Emergence phase: 1.0 to 3.0 sec
            progress = (t - 1.0) / 2.0
            logo_alpha = progress
            logo_scale = 0.88 + 0.12 * (1.0 - math.pow(1 - progress, 3))
            vertical_shift = int(30 * (1.0 - progress))
        elif t <= 5.5:
            # Hold phase with subtle pulse
            logo_alpha = 1.0
            logo_scale = 1.0 + 0.02 * math.sin((t - 3.0) * math.pi)
            vertical_shift = 0
        elif t <= 6.2:
            # Scale down 3-5% phase (5.5 to 6.2 sec)
            progress = (t - 5.5) / 0.7
            logo_alpha = 1.0
            logo_scale = 1.0 - 0.04 * progress
            vertical_shift = 0
        else:
            # Fade out phase (6.2 to 7.0 sec)
            progress = (t - 6.2) / 0.8
            logo_alpha = max(0.0, 1.0 - progress)
            logo_scale = 0.96
            vertical_shift = 0

        # Render Logo onto Canvas
        if logo_alpha > 0.001:
            curr_w = int(target_w * logo_scale)
            curr_h = int(target_h * logo_scale)
            
            if curr_w > 10 and curr_h > 10:
                logo_resized_curr = cv2.resize(logo_np, (curr_w, curr_h), interpolation=cv2.INTER_AREA)
                mask_curr = cv2.resize(mask_np, (curr_w, curr_h), interpolation=cv2.INTER_AREA)

                center_x = width // 2
                center_y = height // 2 + vertical_shift

                top_left_x = center_x - curr_w // 2
                top_left_y = center_y - curr_h // 2

                # Crop ROI bounds
                x1 = max(0, top_left_x)
                y1 = max(0, top_left_y)
                x2 = min(width, top_left_x + curr_w)
                y2 = min(height, top_left_y + curr_h)

                lx1 = x1 - top_left_x
                ly1 = y1 - top_left_y
                lx2 = lx1 + (x2 - x1)
                ly2 = ly1 + (y2 - y1)

                if (x2 > x1) and (y2 > y1):
                    logo_rgb = logo_resized_curr[ly1:ly2, lx1:lx2, :3] # BGR
                    # Convert RGB to BGR
                    logo_bgr = logo_rgb[:, :, ::-1]
                    
                    eff_alpha = (mask_curr[ly1:ly2, lx1:lx2, None] * logo_alpha)

                    # Light sweep shine effect across logo (2.5 to 4.5 sec)
                    if 2.5 <= t <= 4.5:
                        sweep_progress = (t - 2.5) / 2.0
                        sweep_x = int((sweep_progress * 2.2 - 0.6) * curr_w)
                        
                        Y_crop, X_crop = np.ogrid[:y2-y1, :x2-x1]
                        line_dist = np.abs(X_crop - Y_crop*0.4 - sweep_x)
                        shine = np.clip(1.0 - line_dist / 60.0, 0.0, 1.0)
                        logo_bgr = logo_bgr + shine[:, :, None] * 70.0

                    canvas[y1:y2, x1:x2] = canvas[y1:y2, x1:x2] * (1.0 - eff_alpha) + logo_bgr * eff_alpha

        # Final conversion to uint8 frame
        final_frame = np.clip(canvas, 0, 255).astype(np.uint8)
        out.write(final_frame)

    out.release()
    print("Cinematic Splash Video successfully generated at: " + output_path)

if __name__ == '__main__':
    generate_splash_video()
