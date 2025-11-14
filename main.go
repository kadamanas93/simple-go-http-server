package main

import (
	"fmt"
	"log"
	"net/http"
)

// Change this value to change the color of the box
// Try: "red", "blue", "green", "purple", "orange", "#FF5733", etc.
const BoxColor = "blue"

func main() {
	http.HandleFunc("/", handleHome)

	port := "8090"
	fmt.Printf("Server starting on http://localhost:%s\n", port)
	fmt.Printf("Current box color: %s\n", BoxColor)

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func handleHome(w http.ResponseWriter, r *http.Request) {
	html := fmt.Sprintf(`
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Color Box</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }
        .container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        .color-box {
            width: 300px;
            height: 300px;
            background-color: %s;
            border-radius: 15px;
            margin: 20px auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .color-box:hover {
            transform: scale(1.05);
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .color-name {
            color: %s;
            font-size: 24px;
            font-weight: bold;
            margin-top: 20px;
        }
        .info {
            color: #666;
            margin-top: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎨 Simple Color Box</h1>
        <div class="color-box"></div>
        <div class="color-name">%s</div>
        <div class="info">
            To change the color, edit the <code>BoxColor</code> constant in <code>main.go</code>
        </div>
    </div>
</body>
</html>
	`, BoxColor, BoxColor, BoxColor)

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	fmt.Fprint(w, html)
}
