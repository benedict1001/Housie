<%@ Page Title="" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminappeals.aspx.cs" Inherits="WebApplication2.adminappeals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        .page-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; font-family: 'Inter', sans-serif; }
        .page-title { font-size: 28px; font-weight: 800; margin-bottom: 25px; color: #222; font-family: 'Plus Jakarta Sans', sans-serif; }

        /* Table Styles */
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; border: 1px solid #eee; margin-bottom: 40px; }
        .table { width: 100%; border-collapse: collapse; margin-bottom: 0; }
        .table th { background: #f8f9fa; padding: 18px 20px; text-align: left; font-size: 12px; color: #666; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid #eee; }
        .table td { padding: 18px 20px; font-size: 14px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        .prop-title { font-weight: 700; color: #222; margin-bottom: 2px; }
        .host-name { color: #717171; font-size: 13px; font-weight: 500; }
        
        .status-badge { padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 700; text-transform: uppercase; }
        .badge-flagged { background: #ffebee; color: #E61E4D; }
        .badge-active { background: #e8f5e9; color: #2e7d32; }

        .btn-view { background: #f1f5f9; color: #334155; border: 1px solid #cbd5e1; padding: 6px 14px; border-radius: 8px; font-weight: 600; font-size: 13px; text-decoration: none; transition: 0.2s; border: none; cursor: pointer; }
        .btn-view:hover { background: #e2e8f0; color: #0f172a; }

        /* Chat Window Styles */
        .chat-panel { background: white; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); border: 1px solid #eee; padding: 30px; display: none; }
        .chat-panel.active { display: block; animation: slideUp 0.3s ease-out; }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .chat-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .chat-header h3 { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 800; font-size: 20px; color: #222; margin: 0; }
        .btn-close-chat { background: transparent; border: none; font-size: 20px; color: #888; cursor: pointer; transition: 0.2s; }
        .btn-close-chat:hover { color: #E61E4D; }

        .chat-messages { display: flex; flex-direction: column; gap: 15px; max-height: 400px; overflow-y: auto; padding-right: 10px; margin-bottom: 20px; background: #f8f9fa; padding: 20px; border-radius: 12px; }
        .chat-messages::-webkit-scrollbar { width: 6px; }
        .chat-messages::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }

        .chat-bubble { max-width: 75%; padding: 12px 18px; border-radius: 20px; font-size: 14px; line-height: 1.5; position: relative; }
        .chat-timestamp { font-size: 11px; color: #888; margin-top: 5px; text-align: right; }

        .chat-host { background: #fff; border: 1px solid #e2e8f0; color: #334155; align-self: flex-start; border-bottom-left-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .chat-admin { background: #222; color: white; align-self: flex-end; border-bottom-right-radius: 4px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .chat-admin .chat-timestamp { color: rgba(255,255,255,0.7); }

        .chat-input-area { display: flex; gap: 10px; }
        .form-control { border-radius: 12px; border: 1px solid #ddd; padding: 12px 15px; width: 100%; font-family: inherit; font-size: 14px; outline: none; transition: 0.2s; }
        .form-control:focus { border-color: #222; box-shadow: 0 0 0 3px rgba(0,0,0,0.05); }
        
        .btn-send { background: #222; color: white; border: none; padding: 0 24px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.2s; }
        .btn-send:hover { background: #000; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0,0,0,0.1); }

        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px; }
        .btn-unflag { background: #10b981; color: white; border: none; padding: 10px 20px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.2s; text-decoration: none; }
        .btn-unflag:hover { background: #059669; box-shadow: 0 6px 15px rgba(16, 185, 129, 0.2); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="page-container">
        <h1 class="page-title"><i class="fas fa-envelope-open-text me-2 text-primary"></i> Property Appeals</h1>
        <p class="text-muted mb-4">Manage communications from hosts regarding flagged properties.</p>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div class="table-container">
                    <asp:Repeater ID="rptAppealsList" runat="server" OnItemCommand="rptAppealsList_ItemCommand">
                        <HeaderTemplate>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Property ID</th>
                                        <th>Property / Host</th>
                                        <th>Messages</th>
                                        <th>Latest Activity</th>
                                        <th>Current Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong>#<%# Eval("pid") %></strong></td>
                                <td>
                                    <div class="prop-title"><%# Eval("title") %></div>
                                    <div class="host-name"><i class="fas fa-user me-1"></i> <%# Eval("hostfullname") %></div>
                                </td>
                                <td><span class="badge bg-secondary rounded-pill"><%# Eval("MessageCount") %></span></td>
                                <td><span class="text-muted"><%# Convert.ToDateTime(Eval("LatestMessage")).ToString("MMM dd, yyyy HH:mm") %></span></td>
                                <td>
                                    <span class='status-badge <%# Eval("status").ToString() == "4" ? "badge-flagged" : "badge-active" %>'>
                                        <%# Eval("status").ToString() == "4" ? "Flagged" : "Active" %>
                                    </span>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnViewChat" runat="server" CssClass="btn-view" CommandName="ViewChat" CommandArgument='<%# Eval("pid") %>'>
                                        View Chat
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoAppeals" runat="server" Visible="false" CssClass="text-center py-5">
                        <i class="fas fa-check-circle fa-3x text-success mb-3 opacity-50"></i>
                        <h4 class="text-muted">No active appeals right now.</h4>
                        <p class="text-muted small">All host communications have been resolved.</p>
                    </asp:Panel>
                </div>

                <asp:Panel ID="pnlChatInterface" runat="server" CssClass="chat-panel" Visible="false">
                    <div class="chat-header">
                        <div>
                            <h3>Appeal Conversation</h3>
                            <p class="text-muted mb-0 small">Property ID: #<asp:Literal ID="litActivePid" runat="server"></asp:Literal></p>
                        </div>
                        <asp:LinkButton ID="btnCloseChat" runat="server" CssClass="btn-close-chat" OnClick="btnCloseChat_Click"><i class="fas fa-times"></i></asp:LinkButton>
                    </div>

                    <div class="chat-messages" id="adminChatScroll">
                        <asp:Repeater ID="rptChatMessages" runat="server">
                            <ItemTemplate>
                                <div class='chat-bubble <%# Eval("sender_type").ToString() == "Admin" ? "chat-admin" : "chat-host" %>'>
                                    <strong><%# Eval("sender_type") %>:</strong><br />
                                    <%# Eval("message") %>
                                    <div class="chat-timestamp"><%# Convert.ToDateTime(Eval("created_at")).ToString("MMM dd, hh:mm tt") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="chat-input-area">
                        <asp:TextBox ID="txtAdminReply" runat="server" CssClass="form-control" placeholder="Type your reply to the host..." autocomplete="off"></asp:TextBox>
                        <asp:Button ID="btnSendReply" runat="server" Text="Reply" CssClass="btn-send" OnClick="btnSendReply_Click" />
                    </div>

                    <div class="action-bar">
                        <span class="text-muted small"><i class="fas fa-info-circle me-1"></i> If the issue is resolved, you can unflag the property directly.</span>
                        <asp:Button ID="btnUnflag" runat="server" Text="Unflag Property" CssClass="btn-unflag" OnClick="btnUnflag_Click" OnClientClick="return confirm('Are you sure you want to unflag this property? It will be visible to customers again.');" />
                    </div>
                </asp:Panel>

                <asp:HiddenField ID="hfActivePid" runat="server" />

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script>
        // Function to scroll the admin chat to the bottom automatically
        function scrollToBottom() {
            var chatDiv = document.getElementById("adminChatScroll");
            if(chatDiv) {
                chatDiv.scrollTop = chatDiv.scrollHeight;
            }
        }

        // Run on initial load
        window.onload = scrollToBottom;

        // Run after UpdatePanel AJAX postback completes
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function() {
            scrollToBottom();
            
            // Add 'active' class to chat panel to trigger animation if it's visible
            var chatPanel = document.querySelector('.chat-panel');
            if(chatPanel && chatPanel.style.display !== 'none') {
                chatPanel.classList.add('active');
            }
        });
    </script>
</asp:Content>