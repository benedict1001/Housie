<%@ Page Title="Property Appeal" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="flagproperty.aspx.cs" Inherits="WebApplication2.flagproperty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f7f7;
            background-image: linear-gradient(135deg, rgba(255, 255, 255, 0.4) 0%, rgba(255, 255, 255, 0.1) 100%), url('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=1920&auto=format&fit=crop') !important;
            background-size: cover !important;
            background-attachment: fixed !important;
            background-position: center !important;
            color: #2d2f2f;
        }

        .dashboard-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }

        .glass-panel {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0.4) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 1.5rem;
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* Reason Box */
        .alert-box {
            background: rgba(230, 30, 77, 0.1);
            border: 1px solid rgba(230, 30, 77, 0.3);
            border-left: 6px solid #E61E4D;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .alert-title { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 800; color: #b90038; margin-bottom: 8px; font-size: 18px; }
        .alert-text { color: #8e0029; font-size: 15px; font-weight: 500; line-height: 1.6; }

        /* Chat Layout */
        .chat-container { display: flex; flex-direction: column; gap: 15px; max-height: 400px; overflow-y: auto; padding-right: 10px; margin-bottom: 20px; }
        .chat-container::-webkit-scrollbar { width: 6px; }
        .chat-container::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }
        
        .chat-bubble { max-width: 75%; padding: 12px 18px; border-radius: 20px; font-size: 14px; line-height: 1.5; position: relative; }
        .chat-timestamp { font-size: 11px; color: #888; margin-top: 5px; text-align: right; }

        .chat-admin { background: #f1f5f9; border: 1px solid #e2e8f0; color: #334155; align-self: flex-start; border-bottom-left-radius: 4px; }
        .chat-host { background: linear-gradient(135deg, #FA4871 0%, #D70466 100%); color: white; align-self: flex-end; border-bottom-right-radius: 4px; box-shadow: 0 4px 10px rgba(230, 30, 77, 0.2); }
        .chat-host .chat-timestamp { color: rgba(255,255,255,0.8); }

        /* Input Area */
        .chat-input-area { display: flex; gap: 10px; }
        .form-control { border-radius: 12px; border: 1px solid #ddd; padding: 12px 15px; width: 100%; font-family: inherit; font-size: 14px; outline: none; transition: 0.2s; }
        .form-control:focus { border-color: #E61E4D; box-shadow: 0 0 0 3px rgba(230, 30, 77, 0.1); }
        
        .btn-send {
            background: linear-gradient(180deg, #FA4871 0%, #D70466 100%);
            color: white; border: none; padding: 0 24px; border-radius: 12px;
            font-weight: 700; cursor: pointer; transition: 0.2s;
        }
        .btn-send:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(230, 30, 77, 0.3); }

        .back-link { display: inline-block; margin-bottom: 20px; color: #5a5c5c; text-decoration: none; font-weight: 600; transition: 0.2s; }
        .back-link:hover { color: #E61E4D; transform: translateX(-4px); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dashboard-container">
        
        <a href="hosthome.aspx" class="back-link"><i class="fas fa-arrow-left me-2"></i> Back to Dashboard</a>

        <div class="glass-panel">
            <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 20px;">
                <asp:Image ID="imgProperty" runat="server" style="width: 80px; height: 80px; border-radius: 12px; object-fit: cover;" />
                <div>
                    <h2 style="font-size: 22px; font-weight: 800; color: #222;"><asp:Literal ID="litPropTitle" runat="server"></asp:Literal></h2>
                    <p style="color: #717171; margin: 0; font-weight: 500;">Status: <span style="color: #E61E4D; font-weight: 700;"><i class="fas fa-flag"></i> Flagged</span></p>
                </div>
            </div>

            <div class="alert-box">
                <div class="alert-title"><i class="fas fa-exclamation-circle me-2"></i> Reason for Flagging</div>
                <div class="alert-text">
                    <asp:Literal ID="litRejectReason" runat="server">No reason provided by the administrator.</asp:Literal>
                </div>
            </div>

            <h4 style="font-size: 18px; font-weight: 700; margin-bottom: 15px;"><i class="fas fa-comments me-2 text-muted"></i> Appeal / Chat with Admin</h4>
            
            <div class="chat-container" id="chatScroll">
                <asp:Repeater ID="rptChat" runat="server">
                    <ItemTemplate>
                        <div class='chat-bubble <%# Eval("sender_type").ToString() == "Host" ? "chat-host" : "chat-admin" %>'>
                            <strong><%# Eval("sender_type") %>:</strong><br />
                            <%# Eval("message") %>
                            <div class="chat-timestamp"><%# Convert.ToDateTime(Eval("created_at")).ToString("MMM dd, hh:mm tt") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Label ID="lblNoMessages" runat="server" Visible="false" CssClass="text-center text-muted d-block mt-3" Text="No messages yet. Start the conversation below."></asp:Label>
            </div>

            <div class="chat-input-area">
                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Type your message to the admin..." autocomplete="off"></asp:TextBox>
                <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="btn-send" OnClick="btnSend_Click" />
            </div>
        </div>
    </div>

    <script>
        // Auto-scroll chat to bottom
        window.onload = function() {
            var chatDiv = document.getElementById("chatScroll");
            if(chatDiv) {
                chatDiv.scrollTop = chatDiv.scrollHeight;
            }
        };
    </script>
</asp:Content>