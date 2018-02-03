int kx, ky;
int WIDTH = 160;
int HEIGHT = 120;

boolean hsbcolor = false;

void setup() {
    size(1280, 960);
    //fullScreen();
    kx = width / WIDTH;
    ky = height / HEIGHT;
    println(kx, ky);
    background(0);
    noLoop();
    if (hsbcolor) colorMode(HSB, 255);
}

int iterations = 32;
int maxDistSq = 16;
boolean colored = true;

void draw() {
    float w = 4;
    //float h = (w * HEIGHT) / WIDTH;
    float h = w * 0.75;
    
    float xmin = -w/2;
    float ymin = -h/2;
    
    float xmax = xmin + w;
    float ymax = ymin + h;
    
    float dx = (xmax-xmin) / WIDTH;
    float dy = (ymax-ymin) / HEIGHT;
    
    // Start y
    float y = ymin;
    for (int j = 0; j < HEIGHT; j++) {
        float x = xmin;
        for (int i = 0; i < WIDTH; i++) {
            
            if (i == 199 && j == 34) {
                println("hi"); //<>//
            }
            
            // Test and iterate z = z^2 + cm does z -> infty
            float a = x;
            float b = y;
            int n = 0;
            
            while (n < iterations) {
                float aa = a * a;
                float bb = b * b;
                float twoab = 2 * a * b;
                
                a = aa - bb + x;
                b = twoab + y;
                float distance = aa + bb;
                //float distance = aa * aa + bb * bb;
                
                if (distance > maxDistSq) {
                    break;
                }
                n++;
            }
            
            if (n == iterations) {
                stroke(0);
                pixel(i, j);
            } else {
                if (hsbcolor) stroke(map(n, 0, iterations, 10, 190), 255, 255);
                else {
                //stroke(0, map(n, 0, iterations, 50, 255), 50);
                    int mod = n % 8;
                    int c_r = mod / 4;
                    int c_g = (mod / 2) % 2;
                    int c_b = mod % 2;
                    stroke(
                        map(c_r, 0, 1, 0, 255),
                        map(c_g, 0, 1, 0, 255),
                        map(c_b, 0, 1, 0, 255)
                    );
                }
                pixel(i, j);
            }
            
            x += dx;
        }
        y += dy;
    }
}

void pixel(int x, int y) {
    strokeWeight(kx + 1);
    point(x * kx, y * ky);
}