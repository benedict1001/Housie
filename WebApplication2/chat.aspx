<%@ Page Title="Housie Chat" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="chat.aspx.cs" Inherits="WebApplication2.chat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet" />

    <style>
        /* ======================================================
           CHAT PAGE — HOUSIE
           ====================================================== */

        html, body { height: 100%; margin: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            background-image:
                radial-gradient(at 0% 0%,   rgba(185, 0, 56, 0.12) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(106, 70, 174, 0.12) 0px, transparent 50%),
                radial-gradient(at 50% 100%,rgba(255,116,131,0.08) 0px, transparent 50%);
            background-attachment: fixed;
        }

        /* --- LAYOUT SHELL --- */
        .chat-shell {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 72px); /* subtract average master-page nav height */
            max-width: 820px;
            margin: 0 auto;
            padding: 20px 16px 0 16px;
        }

        /* --- TOP INFO BAR --- */
        .chat-header {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 24px;
            background: rgba(255,255,255,0.75);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.9);
            border-radius: 20px 20px 0 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            flex-shrink: 0;
        }

        .chat-header-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 700;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(230,30,77,0.3);
        }

        .chat-header-info { flex: 1; min-width: 0; }
        .chat-header-name {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 17px;
            font-weight: 700;
            color: #1a1a1a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .chat-header-prop {
            font-size: 13px;
            color: #777;
            font-weight: 500;
            margin-top: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .chat-back-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 10px;
            background: rgba(0,0,0,0.05);
            color: #333;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s;
            flex-shrink: 0;
        }
        .chat-back-btn:hover { background: rgba(0,0,0,0.1); color: #111; text-decoration: none; }

        /* --- MESSAGE HISTORY (scrollable) --- */
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 24px 24px 12px 24px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            background: rgba(255,255,255,0.5);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-left: 1px solid rgba(255,255,255,0.8);
            border-right: 1px solid rgba(255,255,255,0.8);
            scroll-behavior: smooth;
        }

        /* Scrollbar styling */
        .chat-messages::-webkit-scrollbar { width: 5px; }
        .chat-messages::-webkit-scrollbar-track { background: transparent; }
        .chat-messages::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.15); border-radius: 10px; }

        /* --- INDIVIDUAL BUBBLE --- */
        .msg-row {
            display: flex;
            align-items: flex-end;
            gap: 10px;
            animation: bubblePop 0.25s ease;
        }
        @keyframes bubblePop {
            from { transform: scale(0.92); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
        }

        .msg-row.sent  { flex-direction: row-reverse; }
        .msg-row.recv  { flex-direction: row; }

        .msg-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, #555 0%, #222 100%);
            color: white;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.12);
        }
        .msg-row.sent  .msg-avatar { background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%); }

        .msg-bubble-wrap { max-width: 68%; display: flex; flex-direction: column; }
        .msg-row.sent  .msg-bubble-wrap { align-items: flex-end; }
        .msg-row.recv  .msg-bubble-wrap { align-items: flex-start; }

        .msg-bubble {
            padding: 11px 16px;
            border-radius: 18px;
            font-size: 14.5px;
            line-height: 1.55;
            word-break: break-word;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }

        .msg-row.sent .msg-bubble {
            background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .msg-row.recv .msg-bubble {
            background: rgba(255,255,255,0.85);
            color: #222;
            border-bottom-left-radius: 4px;
            border: 1px solid rgba(0,0,0,0.06);
        }

        .msg-time {
            font-size: 10.5px;
            color: #aaa;
            margin-top: 4px;
            padding: 0 6px;
            font-weight: 500;
        }

        /* Empty chat state */
        .empty-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #bbb;
            gap: 12px;
            padding: 40px;
            text-align: center;
        }
        .empty-chat i { font-size: 52px; opacity: 0.4; }
        .empty-chat p { font-size: 15px; margin: 0; font-weight: 500; }

        /* --- INPUT BAR (fixed at bottom) --- */
        .chat-input-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            background: rgba(255,255,255,0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.9);
            border-top: 1px solid rgba(0,0,0,0.06);
            border-radius: 0 0 20px 20px;
            box-shadow: 0 -2px 15px rgba(0,0,0,0.05);
            flex-shrink: 0;
        }

        .chat-textbox {
            flex: 1;
            border: 1.5px solid rgba(0,0,0,0.12);
            border-radius: 14px;
            padding: 12px 16px;
            font-size: 14.5px;
            font-family: 'Inter', sans-serif;
            background: rgba(255,255,255,0.7);
            outline: none;
            resize: none;
            min-height: 44px;
            max-height: 130px;
            overflow-y: auto;
            line-height: 1.5;
            color: #222;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .chat-textbox:focus {
            border-color: #E61E4D;
            box-shadow: 0 0 0 3px rgba(230,30,77,0.12);
            background: white;
        }
        .chat-textbox::placeholder { color: #aaa; }

        .chat-send-btn {
            width: 48px;
            height: 48px;
            border: none;
            border-radius: 14px;
            background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%);
            color: white;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.25s ease;
            box-shadow: 0 4px 14px rgba(230,30,77,0.35);
            flex-shrink: 0;
        }
        .chat-send-btn:hover { transform: scale(1.08); box-shadow: 0 6px 18px rgba(230,30,77,0.45); }
        .chat-send-btn:active { transform: scale(0.96); }

        /* --- ERROR / ALERT BANNER --- */
        .chat-alert {
            padding: 12px 20px;
            background: rgba(230,30,77,0.1);
            border: 1px solid rgba(230,30,77,0.25);
            border-radius: 10px;
            color: #b90038;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 12px;
        }

        @media (max-width: 600px) {
            .chat-shell { padding: 8px 6px 0 6px; }
            .chat-header { padding: 14px 16px; border-radius: 14px 14px 0 0; }
            .chat-messages { padding: 16px 14px 8px 14px; }
            .chat-input-bar { padding: 12px 14px; border-radius: 0 0 14px 14px; }
            .msg-bubble-wrap { max-width: 85%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="hfHostId"  runat="server" />
    <asp:HiddenField ID="hfPropId"  runat="server" />
    <asp:HiddenField ID="hfCustId"  runat="server" />

    <div class="chat-shell">

        <%-- TOP HEADER BAR --%>
        <div class="chat-header">
            <a href="javascript:history.back();" class="chat-back-btn">
                <i class="fas fa-chevron-left"></i> Back
            </a>

            <div class="chat-header-avatar" id="hostInitialDiv" runat="server">?</div>

            <div class="chat-header-info">
                <div class="chat-header-name">
                    <asp:Label ID="lblHostName" runat="server" Text="Host"></asp:Label>
                </div>
                <div class="chat-header-prop">
                    <asp:Label ID="lblPropertyName" runat="server" Text="Property"></asp:Label>
                </div>
            </div>
        </div>

        <%-- ERROR LABEL --%>
        <asp:Label ID="lblError" runat="server" Visible="false" CssClass="chat-alert"></asp:Label>

        <%-- MESSAGE HISTORY --%>
        <div class="chat-messages" id="chatMessagesDiv">

            <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                <ItemTemplate>
                    <div class='<%# GetBubbleRowClass(Eval("sender_id").ToString()) %>'>
                        <div class="msg-avatar"><%# GetInitial(Eval("sender_id").ToString()) %></div>
                        <div class="msg-bubble-wrap">
                            <div class="msg-bubble"><%# Server.HtmlEncode(Eval("message_text").ToString()) %></div>
                            <div class="msg-time"><%# Convert.ToDateTime(Eval("sent_date")).ToString("MMM d · h:mm tt") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmptyChat" runat="server" CssClass="empty-chat">
                <i class="fas fa-comments"></i>
                <p>No messages yet.<br />Start the conversation below!</p>
            </asp:Panel>

        </div>

        <%-- INPUT BAR --%>
        <div class="chat-input-bar">
            <asp:TextBox ID="txtMessage" runat="server"
                CssClass="chat-textbox"
                placeholder="Type your message…"
                TextMode="MultiLine"
                Rows="1"
                MaxLength="2000" />

            <asp:Button ID="btnSend" runat="server"
                CssClass="chat-send-btn"
                OnClick="btnSend_Click"
                Text="" />
        </div>

    </div>

    <script>
        // Render the send-button icon (Font Awesome doesn't work inside asp:Button Text)
        document.addEventListener("DOMContentLoaded", function () {
            var btn = document.getElementById('<%= btnSend.ClientID %>');
            if (btn) {
                btn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                btn.title = "Send message";
            }

            // Auto-scroll messages to the bottom on load
            scrollToBottom();

            // Allow Ctrl+Enter / Shift+Enter to stay multi-line; plain Enter submits
            var txt = document.getElementById('<%= txtMessage.ClientID %>');
            if (txt) {
                txt.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' && !e.shiftKey && !e.ctrlKey) {
                        e.preventDefault();
                        document.getElementById('<%= btnSend.ClientID %>').click();
                    }
                });

                // Auto-grow textarea
                txt.addEventListener('input', function () {
                    this.style.height = 'auto';
                    this.style.height = Math.min(this.scrollHeight, 130) + 'px';
                });
            }
        });

        function scrollToBottom() {
            var div = document.getElementById('chatMessagesDiv');
            if (div) { div.scrollTop = div.scrollHeight; }
        }
    </script>

</asp:Content>
