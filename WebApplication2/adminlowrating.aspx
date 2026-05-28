<%@ Page Title="Admin - Low Engagement Properties" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminlowrating.aspx.cs" Inherits="WebApplication2.adminlowrating" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* --- Quality Control Dashboard Styles --- */
        .qc-header {
            max-width: 1600px;
            margin: 40px auto 20px auto;
            padding: 0 40px;
        }

        .qc-title { 
            font-size: 32px; 
            font-weight: 800; 
            color: #E61E4D; 
            margin-bottom: 8px; 
        }

        .qc-subtitle { 
            font-size: 16px; 
            color: #717171; 
            margin-bottom: 30px; 
        }

        /* --- GRID LAYOUT --- */
        .page-wrapper {
            padding: 0 40px 60px 40px;
            max-width: 1600px;
            margin: 0 auto;
        }

        .grid-wrapper {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            width: 100%;
        }

        /* --- PROPERTY CARD --- */
        .property-link { 
            text-decoration: none !important; 
            color: inherit !important; 
            display: block; 
        }

        .property-card { display: flex; flex-direction: column; position: relative; }

        .img-container {
            width: 100%;
            aspect-ratio: 1/1; 
            overflow: hidden;
            border-radius: 16px;
            margin-bottom: 12px;
            position: relative;
            background-color: #f7f7f7;
            border: 1px solid #eee;
        }

        .prop-img { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
            transition: transform 0.3s ease; 
        }

        .property-link:hover .prop-img { transform: scale(1.05); }

        /* --- REVIEW COUNT BADGE --- */
        .count-pill {
            position: absolute;
            top: 12px;
            left: 12px;
            background: #ffffff;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            z-index: 10;
            color: #222;
        }
        .comment-icon { color: #717171; font-size: 12px; }

        .card-body { padding: 4px 0; }
        .card-title { font-weight: 600; font-size: 15px; color: #222; margin-bottom: 2px; }
        .card-info { color: #717171; font-size: 14px; margin-bottom: 2px; }
        .card-price { margin-top: 6px; font-size: 15px; color: #222; }
        
        .alert-label { 
            color: #E61E4D; 
            font-weight: 800; 
            font-size: 11px; 
            text-transform: uppercase; 
            margin-top: 8px; 
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
    </style></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="qc-header">
        <h1 class="qc-title">Low Engagement Properties</h1>
        <p class="qc-subtitle">Identifying properties with 2 or fewer total reviews.</p>
    </div>

    <div class="page-wrapper">
        <div class="grid-wrapper">
            <asp:Repeater ID="rptLowRatedProperties" runat="server">
                <ItemTemplate>
                    <asp:LinkButton ID="btnDetails" runat="server" CssClass="property-link" CommandArgument='<%# Eval("pid") %>' OnClick="btnDetails_Click">
                        <div class="property-card">
                            <div class="img-container">
                                <%-- Displays the actual count of reviews --%>
                                <div class="count-pill">
                                    <i class="fas fa-comment-alt comment-icon"></i> <%# Eval("avg_rating") %> Reviews
                                </div>
                                <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/300" %>' class="prop-img" />
                            </div>
                            <div class="card-body">
                                <div class="card-title"><%# Eval("address") %>, India</div>
                                <div class="card-info"><%# Eval("title") %></div>
                                <div class="card-price"><strong>₹<%# Eval("price") %></strong> night</div>
                                <div class="alert-label">
                                    <i class="fas fa-chart-line"></i> Needs Promotion
                                </div>
                            </div>
                        </div>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <%-- Message shown when all properties have more than 2 reviews --%>
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="text-align:center; padding:100px 20px;">
            <div style="font-size: 50px; color: #00A699; margin-bottom: 20px;">✓</div>
            <h2 style="font-weight: 800;">Engagement is High!</h2>
            <p style="color: #717171;">All properties currently have more than 2 reviews.</p>
        </asp:Panel>
    </div></asp:Content>