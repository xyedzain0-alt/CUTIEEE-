<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>sorry?</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #e59ba8;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            overflow: hidden;
            -webkit-user-select: none;
            user-select: none;
            touch-action: manipulation;
        }

        .card {
            text-align: center;
            padding: 15px;
            width: 100%;
            max-width: 320px; /* Scaled down slightly to perfectly fit Oppo screen widths */
            box-sizing: border-box;
        }

        .gif-container {
            width: 140px; /* Adjusted frame size for mobile viewports */
            height: 140px;
            margin: 0 auto 15px auto;
            background-color: #ffffff;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        }

        .gif-container img {
            width: 85%;
            height: 85%;
            object-fit: contain;
        }

        h2 {
            color: #000000;
            font-size: 22px; /* Adjusted font size so long lines do not wrap heavily */
            font-weight: 600;
            margin: 10px 0 2px 0;
        }

        p {
            color: #222222;
            font-size: 13px;
            margin: 0 0 25px 0;
            font-weight: 500;
        }

        .btn-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            width: 100%;
            position: relative;
            height: 50px;
        }

        button {
            padding: 10px 22px;
            font-size: 15px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            font-weight: 500;
            min-width: 85px;
        }

        #yesBtn {
            background-color: #ffffff;
            color: #000000;
        }

        #noBtn {
            background-color: #ffffff;
            color: #000000;
            position: relative;
            z-index: 999;
        }
    </style>
</head>
<body>

    <audio id="bgMusic" loop>
        <source src="https://pub-c5e31b5cdafb419a86a69d5d340a9929.r2.dev/prem_ki_naiyya_remix.mp3" type="audio/mpeg">
    </audio>

    <div class="card">
        <div class="gif-container">
            <img id="statusGif" src="https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3NndXp6Ym10Z3V6cHZ0ZndsdW9wZWh3YmFndXN0cmR0bDJ0ZXZjZSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/Cdf860GvX8pE4/giphy.gif" alt="Cute Cat">
        </div>
        <h2 id="question">sorry yrr? 🤗</h2>
        <p id="subtext">nhi to ekhi option h</p>

        <div class="btn-container">
            <button id="yesBtn" onclick="selectYes()">Yes</button>
            <button id="noBtn" onmouseover="moveNoButton()" ontouchstart="moveNoButton()" onclick="moveNoButton()">No</button>
        </div>
    </div>

    <script>
        let stage = 0;
        let musicStarted = false;

        const questions = [
            "sorry yrrr? 🤗",
            "Please think again! 🤔",
            "Ek aur baar Soch lo! 🥺",
            "beautiful pls Man jao na! Kitna code likh waogi 😭"
        ];

        const subtexts = [
            "nhi to ekhi option h",
            "itni jaldi na maat bolo! 🥺",
            "kyu aisa kar rahi ho Pls Maan jao 😭",
            "bhot glt baat hai yr x"
        ];

        const gifs = [
            "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3NndXp6Ym10Z3V6cHZ0ZndsdW9wZWh3YmFndXN0cmR0bDJ0ZXZjZSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/Cdf860GvX8pE4/giphy.gif",          
            "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExbXN6cmN4Z3R5Y3d6bXRuMWh5Nm95NnU4YnR0eWd3Y280MTh3dHh0ciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/9Y1leFKs6I0co89Zgq/giphy.gif",          
            "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExbnk1N3Nnd3p4N3ptMmtwYm9pZndpcnR3bzh5N3M2amw5ZXh0bXNjaSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/7SF5scGB2AFrbJJxa3/giphy.gif",          
            "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExbW8xdm9mN2M2MzZwbXhkNDMxbDZ0YW80Y2tveHp0bW5reXlpcHdzdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/K6bOat9ILUSvC/giphy.gif"           
        ];

        function startMusic() {
            if (!musicStarted) {
                const audio = document.getElementById("bgMusic");
                audio.play().catch(error => console.log(error));
                musicStarted = true;
            }
        }

        function moveNoButton() {
            startMusic(); 
            stage++;

            if (stage < 4) {
                document.getElementById("question").innerText = questions[stage];
                document.getElementById("subtext").innerText = subtexts[stage];
                document.getElementById("statusGif").src = gifs[stage];
            }

            const noBtn = document.getElementById("noBtn");
            
            // High security padding zones for Oppo A5 aspect ratio
            const paddingX = 40; 
            const paddingY = 80; // Larger padding vertically keeps button away from Android status bar & nav keys

            const maxX = window.innerWidth - noBtn.offsetWidth - paddingX;
            const maxY = window.innerHeight - noBtn.offsetHeight - paddingY;

            // Generate clean random bounds within your safe viewport space
            const randomX = Math.floor(Math.random() * (maxX - 20)) + 20;
            const randomY = Math.floor(Math.random() * (maxY - 40)) + 40;

            noBtn.style.position = "fixed";
            noBtn.style.left = randomX + "px";
            noBtn.style.top = randomY + "px";
        }

        function selectYes() {
            startMusic(); 
            document.getElementById("question").innerText = "I knew it! ap bht achi ho 🥰";
            document.getElementById("subtext").innerText = "hehe ❤️";
            document.getElementById("statusGif").src = "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHg1cjNkcXl4bnVtcXU0M3hkbW1wM3RjdjRzMDR3NjR0eW0xbTFqdyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/l4pTdcifPZaXv5U5O/giphy.gif"; 
            
            document.querySelector(".btn-container").style.display = "none";
        }
    </script>
</body>
</html>
