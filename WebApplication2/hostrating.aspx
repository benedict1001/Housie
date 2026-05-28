<%@ Page Title="Property Ratings & Reviews" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hostrating.aspx.cs" Inherits="WebApplication2.hostrating" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- HOUSIE THEME STYLES --- */
        body { font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif; background-color: #f7f7f9; color: #222222; }
        .page-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 32px; font-weight: 800; margin-bottom: 30px; color: #222222; }

        /* --- ACCORDION / PROPERTY CARD --- */
        .property-card { background: #ffffff; border-radius: 16px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); margin-bottom: 20px; overflow: hidden; border: 1px solid #ebebeb; transition: box-shadow 0.2s ease; }
        .property-card:hover { box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); }
        .property-header { padding: 20px; display: flex; align-items: center; cursor: pointer; background: #ffffff; border-bottom: 1px solid transparent; transition: background 0.2s; }
        .property-header:hover { background: #fdfafb; }
        .property-img { width: 80px; height: 80px; border-radius: 12px; object-fit: cover; margin-right: 20px; }
        
        .property-info { flex-grow: 1; display: flex; align-items: center; justify-content: space-between; padding-right: 20px; }
        .property-title { font-size: 18px; font-weight: 700; margin: 0 0 5px 0; }
        .property-loc { color: #717171; font-size: 14px; margin: 0; }
        
        /* Stats Badges */
        .stats-container { display: flex; gap: 10px; align-items: center; }
        .rating-badge { background: #fff8e1; padding: 6px 14px; border-radius: 20px; font-size: 14px; font-weight: 800; color: #f57f17; display: flex; align-items: center; gap: 4px; }
        .review-count-badge { background: #f0f0f0; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700; color: #444; }

        .expand-icon { font-size: 20px; color: #222222; transition: transform 0.3s ease; }
        
        /* --- REVIEWS LIST (Inside the fold) --- */
        .reviews-container { display: none; padding: 20px; background: #fafafa; border-top: 1px solid #ebebeb; max-height: 450px; overflow-y: auto; scroll-behavior: smooth; }
        .reviews-container::-webkit-scrollbar { width: 6px; }
        .reviews-container::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 4px; }
        
        .review-item { background: #ffffff; border: 1px solid #e1e1e1; border-radius: 12px; padding: 20px; margin-bottom: 12px; }
        .review-item:last-child { margin-bottom: 0; }
        
        .review-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .review-guest { font-weight: 700; font-size: 15px; color: #222; }
        .review-date { font-size: 13px; color: #717171; }
        
        .review-stars { color: #f57f17; font-size: 14px; margin-bottom: 8px; letter-spacing: 2px; }
        .review-text { font-size: 15px; color: #444; line-height: 1.5; margin: 0; }
    </style>
    
    <script type="text/javascript">
        function toggleReviews(id, iconId) {
            var container = document.getElementById(id);
            var icon = document.getElementById(iconId);

            if (container.style.display === "block") {
                container.style.display = "none";
                icon.style.transform = "rotate(0deg)";
            } else {
                container.style.display = "block";
                icon.style.transform = "rotate(180deg)";
            }
        }
    </script></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <h1 class="page-title">Property Reviews</h1>

        <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
            <ItemTemplate>
                <div class="property-card">
                    
                    <div class="property-header" onclick="toggleReviews('reviews_<%# Eval("pid") %>', 'icon_<%# Eval("pid") %>')">
                        <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/150" %>' class="property-img" />
                        
                        <div class="property-info">
                            <div>
                                <h3 class="property-title"><%# Eval("title") %></h3>
                                <p class="property-loc"><%# Eval("district") %></p>
                            </div>
                            <div class="stats-container">
                                <div class="rating-badge">★ <%# Convert.ToDouble(Eval("avgrating")).ToString("0.0") %></div>
                                <div class="review-count-badge"><%# Eval("totalreviews") %> Reviews</div>
                            </div>
                        </div>

                        <div class="expand-icon" id='icon_<%# Eval("pid") %>'>▼</div>
                    </div>

                    <div class="reviews-container" id='reviews_<%# Eval("pid") %>'>
                        
                        <asp:Repeater ID="rptReviews" runat="server">
                            <ItemTemplate>
                                <div class="review-item">
                                    <div class="review-header">
                                        <%-- FIXED: Evaluating 'fname' instead of 'cid' --%>
                                        <div class="review-guest">Reviewed by: <%# Eval("fname") %></div>
                                        <div class="review-date"><%# Convert.ToDateTime(Eval("reviewdate")).ToString("MMMM dd, yyyy") %></div>
                                    </div>
                                    <div class="review-stars">
                                        <%# new String('★', Convert.ToInt32(Eval("rating"))) %><span style="color: #e1e1e1;"><%# new String('★', 5 - Convert.ToInt32(Eval("rating"))) %></span>
                                    </div>
                                    <p class="review-text">"<%# Eval("reviewtext") %>"</p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Label ID="lblNoReviews" runat="server" Visible="false" Text="No reviews for this property yet." CssClass="d-block text-center text-muted py-3 fw-bold"></asp:Label>
                        
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div></asp:Content>