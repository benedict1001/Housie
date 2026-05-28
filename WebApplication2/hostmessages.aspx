<%@ Page Title="Messages - Housie Host" Language="C#" MasterPageFile="~/hostmasterpage.Master"
    AutoEventWireup="true" CodeBehind="hostmessages.aspx.cs" Inherits="WebApplication2.hostmessages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet" />

    <style>
        /* ============================================================
           HOST INBOX — HOUSIE
           ============================================================ */

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            background-image:
                radial-gradient(at 0%   0%,  rgba(185,0,56,.12)  0px, transparent 50%),
                radial-gradient(at 100% 0%,  rgba(106,70,174,.12) 0px, transparent 50%),
                radial-gradient(at 50%  100%,rgba(255,116,131,.08) 0px, transparent 50%);
            background-attachment: fixed;
        }

        .inbox-shell {
            max-width: 820px;
            margin: 0 auto;
            padding: 32px 16px 60px;
        }

        /* ---- Page heading ---- */
        .inbox-heading {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: #1a1a1a;
            letter-spacing: -0.03em;
            margin-bottom: 8px;
        }
        .inbox-sub {
            font-size: 14px;
            color: #888;
            font-weight: 500;
            margin-bottom: 32px;
        }

        /* ---- Conversation list card ---- */
        .conv-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .conv-row {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 20px;
            background: rgba(255,255,255,0.75);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.9);
            border-radius: 18px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            text-decoration: none;
            color: inherit;
            transition: transform 0.22s ease, box-shadow 0.22s ease;
            cursor: pointer;
            position: relative;
        }
        .conv-row:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 28px rgba(0,0,0,0.09);
            text-decoration: none;
            color: inherit;
        }
        .conv-row.has-unread {
            border-left: 4px solid #E61E4D;
        }

        /* Avatar */
        .conv-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, #334155 0%, #1e293b 100%);
            color: white;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 20px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }

        /* Text block */
        .conv-body { flex: 1; min-width: 0; }

        .conv-top {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 4px;
        }
        .conv-name {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: #1a1a1a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 55%;
        }
        .conv-time {
            font-size: 12px;
            color: #aaa;
            font-weight: 500;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .conv-prop {
            font-size: 12px;
            color: #E61E4D;
            font-weight: 700;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .conv-snippet {
            font-size: 13.5px;
            color: #666;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.4;
        }
        .conv-row.has-unread .conv-snippet {
            color: #333;
            font-weight: 600;
        }

        /* Unread pill */
        .conv-badge {
            flex-shrink: 0;
            min-width: 22px;
            height: 22px;
            padding: 0 6px;
            border-radius: 20px;
            background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%);
            color: white;
            font-size: 11px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 6px rgba(230,30,77,.4);
        }

        /* Arrow */
        .conv-arrow {
            color: #ccc;
            font-size: 16px;
            flex-shrink: 0;
            transition: transform 0.2s;
        }
        .conv-row:hover .conv-arrow { transform: translateX(4px); color: #E61E4D; }

        /* Empty state */
        .empty-inbox {
            text-align: center;
            padding: 70px 40px;
            background: rgba(255,255,255,0.6);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.9);
        }
        .empty-inbox i { font-size: 56px; opacity: 0.3; color: #E61E4D; margin-bottom: 20px; display: block; }
        .empty-inbox h4 {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 20px;
            font-weight: 800;
            color: #444;
            margin-bottom: 8px;
        }
        .empty-inbox p { font-size: 14px; color: #888; margin: 0; }

        @media (max-width: 560px) {
            .conv-name { max-width: 45%; font-size: 15px; }
            .conv-row { padding: 14px 15px; gap: 12px; }
            .conv-avatar { width: 44px; height: 44px; font-size: 17px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="inbox-shell">

        <h1 class="inbox-heading"><i class="fas fa-comment-dots me-2" style="color:#E61E4D;font-size:1.7rem;vertical-align:middle;"></i>Messages</h1>
        <p class="inbox-sub">All conversations with your guests, organised by property.</p>

        <%-- Error banner --%>
        <asp:Label ID="lblError" runat="server" Visible="false"
            style="display:block;margin-bottom:20px;padding:12px 20px;background:rgba(230,30,77,.1);border:1px solid rgba(230,30,77,.25);border-radius:10px;color:#b90038;font-size:14px;font-weight:500;">
        </asp:Label>

        <div class="conv-list">
            <asp:Repeater ID="rptConversations" runat="server">
                <ItemTemplate>
                    <%-- Each row is a clickable anchor that routes to chat.aspx --%>
                    <a href='<%# "chat.aspx?hostId=" + Eval("host_id") + "&custId=" + Eval("sender_id") + "&propId=" + Eval("property_id") %>'
                       class='<%# Convert.ToInt32(Eval("unread_count")) > 0 ? "conv-row has-unread" : "conv-row" %>'>

                        <%-- Avatar: first letter of customer name --%>
                        <div class="conv-avatar"><%# GetInitial(Eval("customer_name").ToString()) %></div>

                        <div class="conv-body">
                            <div class="conv-top">
                                <div class="conv-name"><%# Server.HtmlEncode(Eval("customer_name").ToString()) %></div>
                                <div class="conv-time"><%# FormatTime(Eval("latest_date")) %></div>
                            </div>
                            <div class="conv-prop">
                                <i class="fas fa-home"></i>
                                <%# Server.HtmlEncode(Eval("property_title").ToString()) %>
                            </div>
                            <div class="conv-snippet"><%# Server.HtmlEncode(Eval("latest_message").ToString()) %></div>
                        </div>

                        <%-- Unread badge (visible only when count > 0) --%>
                        <%# Convert.ToInt32(Eval("unread_count")) > 0
                                ? "<div class=\"conv-badge\">" + (Convert.ToInt32(Eval("unread_count")) > 99 ? "99+" : Eval("unread_count").ToString()) + "</div>"
                                : "" %>

                        <div class="conv-arrow"><i class="fas fa-chevron-right"></i></div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-inbox">
            <i class="fas fa-inbox"></i>
            <h4>No messages yet</h4>
            <p>When guests send you a message about one of your properties, it will appear here.</p>
        </asp:Panel>

    </div>
</asp:Content>
