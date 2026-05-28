<%@ Page Title="Admin - View All Properties" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminviewallproperty.aspx.cs" Inherits="WebApplication2.adminviewallproperty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* --- GLOBAL STYLES --- */
        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif;
            color: #222222;
            background-color: #ffffff;
            margin: 0;
            padding: 0;
        }

        /* --- MODERN SEARCH PILL --- */
        .search-bar-container {
            display: flex;
            align-items: center;
            background: #ffffff;
            border-radius: 50px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            border: 1px solid #dddddd;
            max-width: 650px; 
            margin: 40px auto; 
            padding: 8px 8px 8px 24px;
            transition: box-shadow 0.2s ease;
        }

        .search-bar-container:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .search-section {
            display: flex;
            flex-direction: column;
            flex: 1;
            padding: 8px 16px;
            border-radius: 50px;
            transition: background-color 0.2s ease;
            cursor: pointer;
        }

        .search-section:hover { background-color: #f7f7f7; }

        .search-divider {
            height: 32px;
            width: 1px;
            background-color: #dddddd;
            margin: 0 4px;
        }

        .search-label {
            font-size: 12px;
            font-weight: 800;
            color: #222222;
            margin-bottom: 2px;
            letter-spacing: 0.5px;
        }

        .search-input {
            border: none;
            background: transparent;
            outline: none;
            font-size: 14px;
            color: #717171;
            width: 100%;
            padding: 0;
            font-family: inherit;
        }

        /* Removes default dropdown arrow for a cleaner look */
        select.search-input {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            cursor: pointer;
        }

        .search-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-left: 10px;
        }

        .btn-show-all {
            background-color: #ffffff;
            color: #222222;
            border: 1px solid #dddddd;
            border-radius: 30px;
            padding: 10px 16px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-show-all:hover {
            background-color: #f7f7f7;
            border-color: #222222;
        }

        .search-btn {
            background-color: #ff385c;
            color: white !important;
            border-radius: 50%;
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .search-btn:hover { background-color: #d90b36; }

        /* --- CSS GRID FOR PROPERTIES --- */
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

        .property-card {
            display: flex;
            flex-direction: column;
            cursor: pointer;
        }

        .img-container {
            width: 100%;
            aspect-ratio: 1/1; 
            overflow: hidden;
            border-radius: 16px;
            margin-bottom: 12px;
            position: relative;
        }

        .prop-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        /* Gentle zoom effect on hover */
        .property-link:hover .prop-img {
            transform: scale(1.03);
        }

        .card-body { padding: 4px 0; }
        .card-title { font-weight: 600; font-size: 15px; color: #222; margin-bottom: 2px; }
        .card-info { color: #717171; font-size: 14px; margin-bottom: 2px; }
        .card-price { margin-top: 6px; font-size: 15px; color: #222; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <%-- SEARCH PILL --%>
    <div class="search-bar-container">
        <div class="search-section">
            <span class="search-label">Where</span>
            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="search-input">
                <asp:ListItem Text="Search destinations" Value="0"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="search-divider"></div>

        <div class="search-section">
            <span class="search-label">Who</span>
            <asp:TextBox ID="txtGuestNo" runat="server" CssClass="search-input" TextMode="Number" placeholder="Add guests" min="1"></asp:TextBox>
        </div>

        <div class="search-actions">
            <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn-show-all" OnClick="btnShowAll_Click" />
            <asp:LinkButton ID="btnSearch" runat="server" CssClass="search-btn" OnClick="btnSearch_Click">
                <svg viewBox="0 0 32 32" style="fill:none; height:16px; width:16px; stroke:white; stroke-width:4; overflow:visible;">
                    <path d="m13 24c6.0751322 0 11-4.9248678 11-11 0-6.07513225-4.9248678-11-11-11-6.07513225 0-11 4.92486775-11 11 0 6.0751322 4.92486775 11 11 11zm8-3 9 9"></path>
                </svg>
            </asp:LinkButton>
        </div>
    </div>

    <%-- PROPERTIES GRID --%>
    <div class="page-wrapper">
        
        <%-- FLAGGED PROPERTIES SECTION --%>
        <asp:Panel ID="pnlFlaggedSection" runat="server" Visible="false">
            <h2 style="font-size:22px; font-weight:700; color:#E61E4D; margin-bottom:20px;">Flagged Properties (Needs Attention)</h2>
            <div class="grid-wrapper" style="margin-bottom: 40px;">
                <asp:Repeater ID="rptFlaggedProperties" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDetails" runat="server" CssClass="property-link" CommandArgument='<%# Eval("pid") + "|" + Eval("hid") %>' OnClick="btnDetails_Click">
                            
                            <%-- Specific styling for flagged cards --%>
                            <div class="property-card" style="border: 2px solid #E61E4D; border-radius: 16px; padding: 6px; box-sizing: border-box;">
                                <div class="img-container" style="margin-bottom: 8px; border-radius: 10px;">
                                    
                                    <%-- Flagged Badge --%>
                                    <div style="position: absolute; top: 12px; left: 12px; background: #E61E4D; color: white; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 800; text-transform: uppercase; z-index: 10;">
                                        Flagged
                                    </div>

                                    <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/300" %>' class="prop-img" />
                                </div>
                                <div class="card-body">
                                    <div class="card-title"><%# Eval("address") %>, India</div>
                                    <div class="card-info"><%# Eval("title") %></div>
                                    <div class="card-info">Up to <%# Eval("guestno") %> guests</div>
                                    <div class="card-price"><strong>₹<%# Eval("price") %></strong> night</div>
                                </div>
                            </div>

                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <hr style="border: none; border-top: 1px solid #eee; margin-bottom: 40px;" />
        </asp:Panel>

        <%-- ACTIVE PROPERTIES SECTION --%>
        <h2 id="hdgActiveProperties" runat="server" style="font-size:22px; font-weight:700; color:#222222; margin-bottom:20px;">Active Properties</h2>
        <div class="grid-wrapper">
            <asp:Repeater ID="rptProperties" runat="server">
                <ItemTemplate>
                    <asp:LinkButton ID="btnDetails" runat="server" CssClass="property-link" CommandArgument='<%# Eval("pid") + "|" + Eval("hid") %>' OnClick="btnDetails_Click">
                        <div class="property-card">
                            <div class="img-container">
                                <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/300" %>' class="prop-img" />
                            </div>
                            <div class="card-body">
                                <div class="card-title"><%# Eval("address") %>, India</div>
                                <div class="card-info"><%# Eval("title") %></div>
                                <div class="card-info">Up to <%# Eval("guestno") %> guests</div>
                                <div class="card-price"><strong>₹<%# Eval("price") %></strong> night</div>
                            </div>
                        </div>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <%-- NO RESULTS MESSAGE --%>
        <asp:Label ID="lblNoResults" runat="server" Text="We couldn't find any active stays for your search." Visible="false" style="text-align:center; display:block; padding:60px 20px; font-size:18px; font-weight:600; color:#222;"></asp:Label>
    </div>
</asp:Content>