<%@ Page Title="Property Bookings" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hostbooking.aspx.cs" Inherits="WebApplication2.hostbooking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body { font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif; background-color: #f7f7f9; color: #222222; }
        .page-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 32px; font-weight: 800; margin-bottom: 30px; color: #222222; }
        .property-card { background: #ffffff; border-radius: 16px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); margin-bottom: 20px; overflow: hidden; border: 1px solid #ebebeb; transition: box-shadow 0.2s ease; }
        .property-card:hover { box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); }
        .property-header { padding: 20px; display: flex; align-items: center; cursor: pointer; background: #ffffff; border-bottom: 1px solid transparent; transition: background 0.2s; }
        .property-header:hover { background: #fdfafb; }
        .property-img { width: 80px; height: 80px; border-radius: 12px; object-fit: cover; margin-right: 20px; }
        .property-info { flex-grow: 1; display: flex; align-items: center; justify-content: space-between; padding-right: 20px; }
        .property-title { font-size: 18px; font-weight: 700; margin: 0 0 5px 0; }
        .property-loc { color: #717171; font-size: 14px; margin: 0; }
        .expand-icon { font-size: 20px; color: #222222; transition: transform 0.3s ease; }
        
        /* NEW: Total Bookings Badge */
        .total-badge { background: #f0f0f0; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700; color: #444; }

        /* The scrollable container must be relative for Javascript offset to work */
        .bookings-container { display: none; padding: 20px; background: #fafafa; border-top: 1px solid #ebebeb; max-height: 450px; overflow-y: auto; position: relative; scroll-behavior: smooth; }
        .bookings-container::-webkit-scrollbar { width: 6px; }
        .bookings-container::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 4px; }
        
        .booking-item { background: #ffffff; border: 1px solid #e1e1e1; border-radius: 12px; padding: 15px 20px; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; }
        .booking-item:last-child { margin-bottom: 0; }
        .booking-dates { font-weight: 600; font-size: 15px; color: #222; }
        .booking-guest { font-size: 14px; color: #717171; margin-top: 4px; }
        .booking-price { font-weight: 700; font-size: 16px; color: #E61E4D; }
        
        /* NEW: Past and Future Booking Styles */
        .past-booking { opacity: 0.55; background-color: #fdfdfd; } /* Dims old bookings */
        .future-booking { border-left: 4px solid #E61E4D; } /* Highlights upcoming bookings */

        .status-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .badge-Completed { background: #eeeeee; color: #666666; }
        .badge-Ongoing { background: #e3f2fd; color: #1565c0; }
        .badge-Upcoming { background: #e8f5e9; color: #2e7d32; }
    </style>
    
    <script type="text/javascript">
        function toggleBookings(id, iconId) {
            var container = document.getElementById(id);
            var icon = document.getElementById(iconId);

            if (container.style.display === "block") {
                container.style.display = "none";
                icon.style.transform = "rotate(0deg)";
            } else {
                container.style.display = "block";
                icon.style.transform = "rotate(180deg)";

                // AUTO-SCROLL LOGIC: Find the first future booking inside this container
                var closestFuture = container.querySelector('.future-booking');

                if (closestFuture) {
                    // Scroll to the closest future date
                    container.scrollTop = closestFuture.offsetTop - container.offsetTop - 15;
                } else {
                    // If all bookings are in the past, scroll to the very bottom to show the most recent past booking
                    container.scrollTop = container.scrollHeight;
                }
            }
        }
    </script></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <h1 class="page-title">Property Bookings</h1>

        <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
            <ItemTemplate>
                <div class="property-card">
                    
                    <div class="property-header" onclick="toggleBookings('bookings_<%# Eval("pid") %>', 'icon_<%# Eval("pid") %>')">
                        <img src='<%# Eval("pimage") != DBNull.Value ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/150" %>' class="property-img" />
                        
                        <div class="property-info">
                            <div>
                                <h3 class="property-title"><%# Eval("title") %></h3>
                                <p class="property-loc"><%# Eval("district") %></p>
                            </div>
                            <div class="total-badge"><%# Eval("totalbookings") %> Bookings</div>
                        </div>

                        <div class="expand-icon" id='icon_<%# Eval("pid") %>'>▼</div>
                    </div>

                    <div class="bookings-container" id='bookings_<%# Eval("pid") %>'>
                        
                        <asp:Repeater ID="rptBookings" runat="server">
                            <ItemTemplate>
                                <%-- Applies the specific CSS class generated in the SQL query --%>
                                <div class="booking-item <%# Eval("TimeClass") %>">
                                    <div>
                                        <div class="booking-dates">
                                            <%# Convert.ToDateTime(Eval("checkindate")).ToString("MMM dd, yyyy") %> — <%# Convert.ToDateTime(Eval("checkoutdate")).ToString("MMM dd, yyyy") %>
                                        </div>
                                        <div class="booking-guest">
                                            Booking #<%# Eval("bid") %> • Customer ID: <%# Eval("cid") %> • 
                                            <span class="status-badge badge-<%# Eval("StatusText") %>"><%# Eval("StatusText") %></span>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <div class="booking-price">₹<%# Convert.ToDouble(Eval("totalamount")).ToString("N0") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Label ID="lblNoBookings" runat="server" Visible="false" Text="No bookings for this property yet." CssClass="d-block text-center text-muted py-3 fw-bold"></asp:Label>
                        
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div></asp:Content>