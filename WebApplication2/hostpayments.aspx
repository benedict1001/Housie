<%@ Page Title="Earnings & Payments" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hostpayments.aspx.cs" Inherits="WebApplication2.hostpayments" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- KEEPING YOUR EXISTING DESIGN --- */
        body { font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif; background-color: #f7f7f9; color: #222222; }
        .page-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 32px; font-weight: 800; margin-bottom: 20px; color: #222222; }
        
        .grand-total-card {
            background: linear-gradient(135deg, #222222 0%, #000000 100%);
            border-radius: 20px;
            padding: 30px 40px;
            color: white;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .total-label { font-size: 16px; font-weight: 600; color: #aaaaaa; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
        .total-amount { font-size: 48px; font-weight: 800; color: #ffffff; }

        .property-card { background: #ffffff; border-radius: 16px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); margin-bottom: 20px; overflow: hidden; border: 1px solid #ebebeb; transition: box-shadow 0.2s ease; }
        .property-card:hover { box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); }
        .property-header { padding: 20px; display: flex; align-items: center; cursor: pointer; background: #ffffff; border-bottom: 1px solid transparent; transition: background 0.2s; }
        .property-header:hover { background: #fdfafb; }
        .property-img { width: 80px; height: 80px; border-radius: 12px; object-fit: cover; margin-right: 20px; }
        
        .property-info { flex-grow: 1; display: flex; align-items: center; justify-content: space-between; padding-right: 20px; }
        .property-title { font-size: 18px; font-weight: 700; margin: 0 0 5px 0; }
        .property-loc { color: #717171; font-size: 14px; margin: 0; }
        
        .stats-container { display: flex; gap: 10px; align-items: center; }
        .total-badge { background: #f0f0f0; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700; color: #444; }
        .earned-badge { background: #ffebee; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700; color: #E61E4D; }

        .expand-icon { font-size: 20px; color: #222222; transition: transform 0.3s ease; }
        
        .payments-container { display: none; padding: 20px; background: #fafafa; border-top: 1px solid #ebebeb; max-height: 400px; overflow-y: auto; scroll-behavior: smooth; }
        .payments-container::-webkit-scrollbar { width: 6px; }
        .payments-container::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 4px; }
        
        .payment-item { background: #ffffff; border: 1px solid #e1e1e1; border-radius: 12px; padding: 15px 20px; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; }
        .payment-dates { font-weight: 600; font-size: 15px; color: #222; }
        .payment-guest { font-size: 14px; color: #717171; margin-top: 4px; }
        .payment-price { font-weight: 800; font-size: 18px; color: #2e7d32; }

        /* --- UPDATED: DYNAMIC STATUS STYLES --- */
        .status-badge {
            font-size: 11px; font-weight: 700; padding: 4px 8px; border-radius: 6px; 
            text-transform: uppercase; margin-left: 10px; vertical-align: middle;
        }
        .status-1 { background: #e3f2fd; color: #1976d2; } /* Confirmed - Blue */
        .status-2 { background: #f5f5f5; color: #9e9e9e; } /* Canceled - Gray */
        .status-3 { background: #fff3e0; color: #f57c00; } /* Checked In - Orange */
        .status-4 { background: #e8f5e9; color: #2e7d32; } /* Completed - Green */

        .payment-item.cancelled { opacity: 0.6; background: #f9f9f9; }
        .payment-item.cancelled .payment-price { color: #9e9e9e; text-decoration: line-through; }
    </style>
    
    <script type="text/javascript">
        function togglePayments(id, iconId) {
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
        <h1 class="page-title">Earnings & Payments</h1>

        <div class="grand-total-card">
            <div class="total-label">Total Lifetime Earnings</div>
            <div class="total-amount">₹<asp:Label ID="lblGrandTotal" runat="server" Text="0.00"></asp:Label></div>
        </div>

        <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
            <ItemTemplate>
                <div class="property-card">
                    <div class="property-header" onclick="togglePayments('payments_<%# Eval("pid") %>', 'icon_<%# Eval("pid") %>')">
                        <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/150" %>' class="property-img" />
                        <div class="property-info">
                            <div>
                                <h3 class="property-title"><%# Eval("title") %></h3>
                                <p class="property-loc"><%# Eval("district") %></p>
                            </div>
                            <div class="stats-container">
                                <div class="total-badge"><%# Eval("totalbookings") %> Bookings</div>
                                <div class="earned-badge">₹<%# Convert.ToDouble(Eval("totalearned")).ToString("N2") %> Earned</div>
                            </div>
                        </div>
                        <div class="expand-icon" id='icon_<%# Eval("pid") %>'>▼</div>
                    </div>

                    <div class="payments-container" id='payments_<%# Eval("pid") %>'>
                        <asp:Repeater ID="rptPayments" runat="server">
                            <ItemTemplate>
                                <%-- UPDATED: Applies 'cancelled' class only if status is 2 --%>
                                <div class='<%# Eval("status").ToString() == "2" ? "payment-item cancelled" : "payment-item" %>'>
                                    <div>
                                        <div class="payment-dates">
                                            Booking Date: <%# Convert.ToDateTime(Eval("bookingdate")).ToString("MMM dd, yyyy") %>
                                            
                                            <%-- UPDATED: Dynamic Status Badge pulling StatusText from backend --%>
                                            <span class='status-badge status-<%# Eval("status") %>'>
                                                <%# Eval("StatusText") %>
                                            </span>
                                        </div>
                                        <div class="payment-guest">
                                            Booking ID: #<%# Eval("bid") %> • Customer ID: <%# Eval("cid") %>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <%-- The backend already passes 0.00 if cancelled, but the CSS will cross it out! --%>
                                        <div class="payment-price">₹<%# Convert.ToDouble(Eval("totalamount")).ToString("N2") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoPayments" runat="server" Visible="false" Text="No payments recorded." CssClass="d-block text-center text-muted py-3 fw-bold"></asp:Label>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div></asp:Content>