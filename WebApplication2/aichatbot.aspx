<%@ Page Title="Housie AI | Kerala Premium Stays" Language="C#" MasterPageFile="~/customermaster.Master"
    AutoEventWireup="true" CodeBehind="aichatbot.aspx.cs" Inherits="WebApplication2.aichatbot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta charset="utf-8" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #FF385C; 
            --bg-light: #F7F7F7;
            --surface: #FFFFFF;
            --text-main: #222222;
            --text-light: #717171;
            --radius: 20px;
        }

        body { background-color: var(--bg-light); }

        .container, .body-content, .container-fluid {
            max-width: 100% !important;
            width: 100% !important;
            padding: 0 !important;
            margin: 0 !important;
        }

        /* ── Layout ────────────────────────────────────────────────────────── */
        .ai-search-layout {
            display: flex;
            width: 100vw;
            height: calc(100vh - 70px);
            background: var(--bg-light);
            overflow: hidden;
            font-family: 'Inter', -apple-system, system-ui, sans-serif;
        }

        /* ── Left side (Properties) ─────────────────────────────────────────── */
        .property-display-area {
            flex: 1;
            padding: 30px 50px;
            overflow-y: auto;
        }

        .header-section { margin-bottom: 30px; }
        .header-section h2 {
            font-weight: 800;
            font-size: 2.2rem;
            color: var(--text-main);
            letter-spacing: -1px;
            margin-bottom: 5px;
        }
        .header-section p { color: var(--text-light); font-size: 1.1rem; margin-top: 0; }

        /* ── Property Card Redesign ────────────────────────────────────────── */
        .property-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 32px;
        }

        .property-card {
            background: transparent;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.2, 0, 0, 1);
            cursor: pointer;
        }

        .img-container {
            position: relative;
            width: 100%;
            padding-top: 90%; /* Modern Landscape Ratio */
            border-radius: 16px;
            overflow: hidden;
            background-color: #ddd;
        }

        .card-img {
            position: absolute;
            top: 0; left: 0; bottom: 0; right: 0;
            background-size: cover;
            background-position: center;
            transition: transform 0.6s ease;
        }

        .property-card:hover .card-img { transform: scale(1.05); }

        .card-body { padding: 12px 4px; }
        .card-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--text-main);
            margin: 0;
            display: flex;
            justify-content: space-between;
        }

        .card-location { color: var(--text-light); font-size: 0.95rem; margin: 4px 0; }

        .card-price { font-size: 1rem; font-weight: 700; color: var(--text-main); margin-top: 6px; }
        .card-price span { font-weight: 400; color: var(--text-light); }

        /* ── Chat Sidebar ───────────────────────────────────────────────────── */
        .chatbot-area {
            width: 420px;
            background: var(--surface);
            border-left: 1px solid #ebebeb;
            display: flex;
            flex-direction: column;
            box-shadow: -10px 0 30px rgba(0,0,0,0.03);
        }

        .chat-sidebar-header {
            padding: 24px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .bot-identity { display: flex; align-items: center; gap: 12px; }
        .bot-avatar {
            width: 40px; height: 40px;
            background: var(--primary);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white;
        }

        .bot-info h3 { margin: 0; font-size: 1rem; font-weight: 700; }
        .bot-info span { font-size: 0.8rem; color: #4ade80; display: flex; align-items: center; gap: 4px; }

        /* ── Messages ───────────────────────────────────────────────────────── */
        #chatMessages {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .msg-bubble {
            max-width: 85%;
            padding: 14px 18px;
            border-radius: 20px;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .msg-user {
            align-self: flex-end;
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 4px;
        }

        .msg-bot {
            align-self: flex-start;
            background: #F3F3F3;
            color: var(--text-main);
            border-bottom-left-radius: 4px;
        }

        /* ── Chat Input ─────────────────────────────────────────────────────── */
        .chat-input-area { padding: 15px 24px 25px; border-top: 1px solid #f0f0f0; }

        .input-wrapper {
            background: #f7f7f7;
            border: 1px solid #ddd;
            border-radius: 30px;
            display: flex;
            align-items: center;
            padding: 6px 6px 6px 18px;
            transition: all 0.2s;
        }

        .input-wrapper:focus-within {
            border-color: var(--text-main);
            background: white;
            box-shadow: 0 0 0 2px rgba(0,0,0,0.05);
        }

        #userInput {
            flex: 1;
            border: none;
            background: transparent;
            outline: none;
            font-size: 0.95rem;
            padding: 8px 0;
            resize: none;
            font-family: inherit;
        }

        #sendBtn {
            width: 38px; height: 38px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: transform 0.2s;
        }
        #sendBtn:hover { transform: scale(1.1); }

        /* ── Chips ─────────────────────────────────────────────────────────── */
        .suggestion-chips {
            display: flex;
            gap: 8px;
            padding: 0 24px 15px;
            overflow-x: auto;
            white-space: nowrap;
        }
        .suggestion-chips::-webkit-scrollbar { display: none; }

        .chip {
            border: 1px solid #ddd;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }
        .chip:hover { border-color: var(--primary); color: var(--primary); }

        /* ── Typing ────────────────────────────────────────────────────────── */
        .typing-indicator { align-self: flex-start; display: none; gap: 4px; padding: 10px; }
        .typing-indicator span { width: 6px; height: 6px; background: #bbb; border-radius: 50%; animation: bounce 1.4s infinite; }
        @keyframes bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ai-search-layout">

        <div class="property-display-area" id="mainDisplay">
            <div class="header-section">
                <h2>Explore Kerala <span style="color:var(--primary)">stays</span></h2>
                <p>Personalized property picks from across the state.</p>
            </div>

            <div id="propertyGridWrapper">
                <div class="property-grid">
                    <asp:Repeater ID="PropertyRepeater" runat="server">
                        <ItemTemplate>
                            <div class="property-card" onclick="window.location.href='customerpropertydetail.aspx?pid=<%# Eval("pid") %>'">
                                <div class="img-container">
                                    <%-- UPDATED: Evaluates the text path directly for instant loading --%>
                                    <div class="card-img" style='background-image:url("<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/600x600?text=Housie+Stay" %>");'></div>
                                </div>
                                <div class="card-body">
                                    <div class="card-title">
                                        <%# Eval("title") %>
                                        <span><i class="fa-solid fa-star" style="font-size:0.8rem"></i> 4.9</span>
                                    </div>
                                    <div class="card-location"><%# Eval("district") %>, Kerala</div>
                                    <div class="card-price">
                                        &#8377;<%# Eval("price", "{0:N0}") %> <span>night</span>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <div class="chatbot-area">
            <div class="chat-sidebar-header">
                <div class="bot-identity">
                    <div class="bot-avatar"><i class="fa-solid fa-robot"></i></div>
                    <div class="bot-info">
                        <h3>Housie AI</h3>
                        <span><i class="fa-solid fa-circle" style="font-size:8px"></i> Active</span>
                    </div>
                </div>
                <i class="fa-solid fa-ellipsis-h" style="color:#ccc"></i>
            </div>

            <div id="chatMessages">
                <div class="msg-bubble msg-bot">
                    Hi Benedict! Ready to find a perfect stay in Kerala? Tell me which district you're interested in.
                </div>
                <div class="typing-indicator" id="typingIndicator">
                    <span></span><span></span><span></span>
                </div>
            </div>

            <div class="suggestion-chips">
                <div class="chip" onclick="sendChip(this)">Stays in Ernakulam</div>
                <div class="chip" onclick="sendChip(this)">Wayanad Resorts</div>
                <div class="chip" onclick="sendChip(this)">Villas in Kottayam</div>
                <div class="chip" onclick="sendChip(this)">Alleppey Houseboats</div>
            </div>

            <div class="chat-input-area">
                <div class="input-wrapper">
                    <textarea id="userInput" rows="1" placeholder="Type a message..." onkeydown="handleKey(event)"></textarea>
                    <button id="sendBtn" onclick="sendMessage()">
                        <i class="fa-solid fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const chatBox = document.getElementById("chatMessages");
        const typingEl = document.getElementById("typingIndicator");
        const inputEl = document.getElementById("userInput");
        const chipsEl = document.querySelector(".suggestion-chips");

        function scrollBottom() { chatBox.scrollTop = chatBox.scrollHeight; }

        function addBubble(text, role) {
            typingEl.style.display = "none";
            const div = document.createElement("div");
            div.className = "msg-bubble " + (role === "user" ? "msg-user" : "msg-bot");
            const cleanText = text.replace(/\[QUERY:pids=[\d,]+\]/g, "");
            div.innerHTML = cleanText.replace(/\n/g, "<br>");
            chatBox.insertBefore(div, typingEl);
            scrollBottom();
        }

        function showTyping() { typingEl.style.display = "flex"; scrollBottom(); }

        function sendMessage() {
            const msg = inputEl.value.trim();
            if (!msg) return;

            chipsEl.style.display = "none";
            addBubble(escapeHtml(msg), "user");
            inputEl.value = "";
            autoResize();
            showTyping();

            $.ajax({
                type: "POST",
                url: "aichatbot.aspx/SendChatMessage",
                data: JSON.stringify({ userMessage: msg }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    const aiResponse = data.d || "No response.";
                    addBubble(aiResponse, "bot");

                    const queryMatch = aiResponse.match(/\[QUERY:pids=([\d,]+)\]/);
                    if (queryMatch && queryMatch[1]) {
                        const pids = queryMatch[1];
                        $("#propertyGridWrapper").fadeOut(300, function () {
                            $(this).load("aichatbot.aspx?pids=" + pids + " #propertyGridWrapper > *", function () {
                                $(this).fadeIn(300);
                            });
                        });
                    }
                },
                error: function () {
                    addBubble("⚠️ Connectivity issue. Check n8n.", "bot");
                }
            });
        }

        function sendChip(el) { inputEl.value = el.textContent.trim(); sendMessage(); }

        function handleKey(e) {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        }

        function autoResize() {
            inputEl.style.height = "auto";
            inputEl.style.height = Math.min(inputEl.scrollHeight, 100) + "px";
        }
        inputEl.addEventListener("input", autoResize);

        function escapeHtml(str) {
            return String(str).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
        }
    </script>
</asp:Content>