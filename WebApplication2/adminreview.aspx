<%@ Page Title="Admin - All Reviews" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminreview.aspx.cs" Inherits="WebApplication2.adminreview" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- HOUSIE THEME STYLES --- */
        body { 
            font-family: 'Inter', sans-serif; 
            background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            background-attachment: fixed;
            color: #222222; 
        }
        
        /* Removed max-width constraint to utilize more screen space */
        .page-container { max-width: 1300px; margin: 30px auto; padding: 30px; background: rgba(255, 255, 255, 0.5); backdrop-filter: blur(10px); border-radius: 24px; border: 1px solid rgba(255, 255, 255, 0.8); box-shadow: 0 10px 30px rgba(0,0,0,0.03); }
        .page-title { font-size: 28px; font-weight: 800; margin-bottom: 30px; color: #1a1a1a; padding-left: 10px; }

        /* --- THE 3 BOX STYLE SUMMARY --- */
        .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .s-card { background: rgba(255,255,255,0.9); padding: 25px; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.04); border-left: 5px solid #E61E4D; transition: transform 0.3s; }
        .s-card:hover { transform: translateY(-5px); }
        .s-label { font-size: 13px; color: #717171; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; }
        .s-value { font-size: 28px; font-weight: 800; color: #222; margin-top: 8px; display: flex; align-items: center; gap: 8px; }
        .s-icon { font-size: 24px; color: #E61E4D; opacity: 0.8; }

        /* --- PROPERTY CARD --- */
        .property-card { background: #ffffff; border-radius: 20px; box-shadow: 0 8px 20px rgba(0,0,0,0.04); margin-bottom: 20px; overflow: hidden; border: 1px solid rgba(0,0,0,0.05); transition: box-shadow 0.2s ease; }
        .property-card:hover { box-shadow: 0 12px 30px rgba(0,0,0,0.08); }
        .property-header { padding: 20px 25px; display: flex; align-items: center; cursor: pointer; transition: background 0.2s; }
        .property-header:hover { background: #fafafa; }
        .prop-img { width: 70px; height: 70px; border-radius: 12px; object-fit: cover; margin-right: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        
        .prop-info { flex-grow: 1; }
        .prop-title { font-size: 17px; font-weight: 700; margin: 0; color: #222; }
        .prop-meta { font-size: 13px; color: #717171; margin-top: 4px; }

        .review-count-badge { background: #fce4e9; color: #E61E4D; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .expand-icon { font-size: 18px; margin-left: 20px; transition: 0.3s; color: #717171; }
        
        /* --- REVIEWS LIST --- */
        .reviews-drawer { display: none; background: #fdfdfd; border-top: 1px solid #f0f0f0; padding: 20px 25px; }
        
        .review-item { background: white; border: 1px solid #f0f0f0; border-radius: 14px; padding: 20px; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: flex-start; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .review-item.low-rating { border-left: 4px solid #dc3545; background: #fffcfc; }
        
        .reviewer-name { font-weight: 700; font-size: 14px; margin-bottom: 4px; color: #111; }
        .review-text { font-size: 14px; color: #555; line-height: 1.6; margin: 8px 0; word-wrap: break-word; }
        .review-date { font-size: 12px; color: #aaa; font-weight: 500; }
        
        .star-active { color: #FFB400; font-size: 11px; }
        .star-inactive { color: #ddd; font-size: 11px; }

        .btn-delete { color: #dc3545; background: #fff5f5; border: 1px solid #ffccd5; padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 600; cursor: pointer; transition: 0.2s; text-decoration: none; }
        .btn-delete:hover { background: #dc3545; color: white; border-color: #dc3545; }
    </style>

    <script>
        function toggleDrawer(id, iconId) {
            var drawer = document.getElementById(id);
            var icon = document.getElementById(iconId);
            if (drawer.style.display === "block") {
                drawer.style.display = "none";
                icon.style.transform = "rotate(0deg)";
            } else {
                drawer.style.display = "block";
                icon.style.transform = "rotate(180deg)";
            }
        }
    </script></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <h1 class="page-title">Reviews Moderation</h1>

        <%-- THE 3 BOX STYLE SUMMARY --%>
        <div class="summary-grid">
            <div class="s-card" style="border-color: #E61E4D;">
                <div class="s-label">Total Reviews</div>
                <div class="s-value">
                    <i class="fas fa-comments s-icon"></i>
                    <asp:Literal ID="litTotalReviews" runat="server" Text="0"></asp:Literal>
                </div>
            </div>
            <div class="s-card" style="border-color: #FFB400;">
                <div class="s-label">Platform Average</div>
                <div class="s-value">
                    <i class="fas fa-star s-icon" style="color: #FFB400;"></i>
                    <asp:Literal ID="litAvgRating" runat="server" Text="0.0"></asp:Literal>
                </div>
            </div>
            <div class="s-card" style="border-color: #dc3545;">
                <div class="s-label">Low Rated (1-2 Stars)</div>
                <div class="s-value">
                    <i class="fas fa-exclamation-triangle s-icon" style="color: #dc3545;"></i>
                    <asp:Literal ID="litCriticalCount" runat="server" Text="0"></asp:Literal>
                </div>
            </div>
        </div>

        <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
            <ItemTemplate>
                <div class="property-card">
                    <div class="property-header" onclick="toggleDrawer('drawer_<%# Eval("pid") %>', 'icon_<%# Eval("pid") %>')">
                        <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/60" %>' class="prop-img" />
                        
                        <div class="prop-info">
                            <h3 class="prop-title"><%# Eval("title") %></h3>
                            <div class="prop-meta"><%# Eval("address") %></div>
                        </div>

                        <div class="review-count-badge">
                            <%# Eval("review_count") %> Reviews
                        </div>

                        <div class="expand-icon" id='icon_<%# Eval("pid") %>'>▼</div>
                    </div>

                    <div class="reviews-drawer" id='drawer_<%# Eval("pid") %>'>
                        <asp:Repeater ID="rptNestedReviews" runat="server" OnItemCommand="rptNestedReviews_ItemCommand">
                            <ItemTemplate>
                                <div class='<%# Convert.ToInt32(Eval("rating")) <= 2 ? "review-item low-rating" : "review-item" %>'>
                                    <div style="flex-grow: 1; padding-right: 20px;">
                                        <div class="reviewer-name"><%# Eval("fname") %></div>
                                        <div><%# GetStars(Convert.ToInt32(Eval("rating"))) %></div>
                                        <p class="review-text"><%# Eval("reviewtext") %></p>
                                        <div class="review-date"><%# Convert.ToDateTime(Eval("reviewdate")).ToString("MMM dd, yyyy") %></div>
                                    </div>
                                    <div class="text-end">
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-delete" 
                                            CommandName="DeleteReview" CommandArgument='<%# Eval("review_id") %>'
                                            OnClientClick="return confirm('Delete this review permanently?');">
                                            Delete
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Label ID="lblNoReviews" runat="server" Visible="false" 
                            Text="This property has no reviews yet." 
                            CssClass="d-block text-center py-3 text-muted fw-bold">
                        </asp:Label>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div></asp:Content>