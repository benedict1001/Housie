<%@ Page Title="Trips - Housie" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customertrips.aspx.cs" Inherits="WebApplication2.customertrips" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    
    <style>
        /* HIDE LOGO HACK */
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        /* --- LUMINOUS EDITORIAL BACKGROUND & TYPOGRAPHY --- */
        body {
            font-family: 'Inter', sans-serif;
            color: #2d2f2f; 
            margin: 0; 
            background-color: #f6f6f6;
            background-image: 
                radial-gradient(at 0% 0%, rgba(185, 0, 56, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(106, 70, 174, 0.15) 0px, transparent 50%),
                radial-gradient(at 50% 100%, rgba(255, 116, 131, 0.1) 0px, transparent 50%);
            background-attachment: fixed; 
            background-repeat: no-repeat;
        }

        .page-title { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            font-size: 3rem; 
            font-weight: 800; 
            margin-bottom: 30px; 
            color: #2d2f2f; 
            letter-spacing: -0.05em; 
        }

        .section-title { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            font-size: 1.8rem; 
            font-weight: 800; 
            margin: 50px 0 24px 0; 
            color: #2d2f2f; 
            letter-spacing: -0.02em;
        }

        .trips-container { 
            max-width: 1200px; 
            margin: 60px auto; 
            padding: 0 40px; 
        }

        .trip-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); 
            gap: 32px; 
        }

        /* --- SKEUOMORPHIC LIQUID GLASS CARDS --- */
        .trip-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(240, 240, 240, 0.4) 100%);
            backdrop-filter: blur(25px); -webkit-backdrop-filter: blur(25px);
            border-top: 2px solid #ffffff;
            border-left: 2px solid #ffffff;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            border-right: 1px solid rgba(0,0,0,0.05);
            border-radius: 24px;
            overflow: hidden; 
            box-shadow: 8px 8px 25px rgba(0,0,0,0.06), -8px -8px 25px rgba(255,255,255,0.9), inset 2px 2px 10px rgba(255,255,255,0.5);
            transition: transform 0.3s ease, box-shadow 0.3s ease; 
            display: flex; flex-direction: column;
            padding: 16px;
        }
        .trip-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 12px 12px 30px rgba(0,0,0,0.1), -12px -12px 30px rgba(255,255,255,1), inset 2px 2px 10px rgba(255,255,255,0.5); 
        }

        .trip-img { 
            width: 100%; height: 220px; object-fit: cover; 
            border-radius: 16px; 
            box-shadow: inset 4px 4px 10px rgba(0,0,0,0.15), inset -4px -4px 10px rgba(255,255,255,0.7);
            border: 4px solid rgba(255,255,255,0.6);
        }
        
        .trip-info { padding: 20px 8px 8px 8px; flex: 1; display: flex; flex-direction: column; }
        
        .trip-location { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 700; margin-bottom: 6px; color: #2d2f2f; }
        .trip-dates { color: #5a5c5c; font-size: 14px; margin-bottom: 12px; font-weight: 500; }
        
        .trip-status { 
            display: inline-block; padding: 6px 14px; border-radius: 20px; 
            font-size: 11px; font-weight: 800; margin-bottom: 20px; letter-spacing: 0.05em; text-transform: uppercase;
        }
        .status-upcoming { background: rgba(0, 166, 153, 0.15); color: #007a70; border: 1px solid rgba(0, 166, 153, 0.3); }
        .status-current { background: rgba(16, 185, 129, 0.15); color: #059669; border: 1px solid rgba(16, 185, 129, 0.3); }
        .status-past { background: rgba(0,0,0,0.05); color: #5a5c5c; border: 1px solid rgba(0,0,0,0.1); }

        .trip-footer {
            margin-top: auto; border-top: 1px solid rgba(0,0,0,0.08); padding-top: 20px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .trip-price { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 800; font-size: 20px; color: #2d2f2f; }
        .action-links { display: flex; flex-direction: column; align-items: flex-end; gap: 10px; }

        .view-details-link { color: #b90038; font-size: 14px; font-weight: 700; text-decoration: none; transition: color 0.2s; }
        .view-details-link:hover { text-decoration: underline; color: #8a0029; }

        /* Physical Cancel Button */
        .cancel-btn {
            background: linear-gradient(180deg, #ffffff 0%, #e6e6e6 100%);
            border: 1px solid #ccc; border-top: 1px solid #fff;
            color: #2d2f2f; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 700; 
            cursor: pointer; transition: all 0.1s ease; text-decoration: none; display: inline-block; text-align: center;
            box-shadow: 0 4px 0 #b3b3b3, 0 6px 10px rgba(0,0,0,0.05);
        }
        .cancel-btn:hover { background: #fdfdfd; }
        .cancel-btn:active { transform: translateY(4px); box-shadow: 0 0 0 #b3b3b3, inset 0 2px 5px rgba(0,0,0,0.1); }

        .review-btn {
            background: linear-gradient(135deg, #00A699 0%, #007a70 100%);
            border: none; color: white; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 700;
            box-shadow: 0 4px 0 #005c54, 0 6px 10px rgba(0, 166, 153, 0.3); text-decoration: none; display: inline-block;
            transition: all 0.1s ease;
        }
        .review-btn:active { transform: translateY(4px); box-shadow: 0 0 0 #005c54, inset 0 2px 5px rgba(0,0,0,0.3); }

        /* Message Host Button */
        .msg-host-btn {
            background: linear-gradient(135deg, rgba(255,255,255,0.8) 0%, rgba(240,240,240,0.6) 100%);
            border: 1.5px solid rgba(0,0,0,0.12);
            color: #2d2f2f;
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
        }
        .msg-host-btn:hover {
            background: rgba(255,255,255,0.95);
            border-color: rgba(0,0,0,0.25);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-1px);
            color: #2d2f2f;
            text-decoration: none;
        }

        /* Empty State Liquid Glass */
        .empty-state { 
            padding: 60px 40px; text-align: center; 
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.6) 0%, rgba(255, 255, 255, 0.2) 100%);
            backdrop-filter: blur(25px); border-radius: 30px;
            border-top: 1.5px solid rgba(255, 255, 255, 0.9); border-left: 1.5px solid rgba(255, 255, 255, 0.9);
            box-shadow: 0 20px 40px rgba(0,0,0,0.05), inset 0 0 20px rgba(255,255,255,0.5);
        }
        .empty-icon { font-size: 64px; color: rgba(185, 0, 56, 0.3); margin-bottom: 24px; filter: drop-shadow(2px 4px 6px rgba(0,0,0,0.1)); }

        /* MODAL STYLES (Glassmorphism) */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4); z-index: 2000;
            justify-content: center; align-items: center; backdrop-filter: blur(8px);
        }
        .modal-box {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(240, 240, 240, 0.85) 100%);
            padding: 40px; border-radius: 24px; width: 90%; max-width: 450px;
            text-align: center; box-shadow: 0 20px 50px rgba(0,0,0,0.3), inset 2px 2px 10px rgba(255,255,255,0.8);
            border: 1px solid rgba(255,255,255,0.9);
            transform: scale(0.95) translateY(20px); opacity: 0; transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .modal-overlay.show { display: flex; }
        .modal-overlay.show .modal-box { transform: scale(1) translateY(0); opacity: 1; }
        
        .modal-icon-warning { font-size: 70px; color: #b90038; margin-bottom: 20px; filter: drop-shadow(0 4px 10px rgba(185,0,56,0.3)); }
        .modal-icon-success { font-size: 70px; color: #00A699; margin-bottom: 20px; filter: drop-shadow(0 4px 10px rgba(0,166,153,0.3)); }
        
        .modal-title { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 26px; font-weight: 800; margin-bottom: 16px; color: #2d2f2f; letter-spacing: -0.02em; }
        .modal-text { font-size: 15px; color: #5a5c5c; margin-bottom: 32px; line-height: 1.6; }

        .modal-actions { display: flex; gap: 16px; justify-content: center; }
        
        .btn-modal-safe { 
            background: linear-gradient(180deg, #444 0%, #222 100%); color: white; border: none; 
            padding: 14px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; flex: 1; 
            box-shadow: 0 4px 0 #000, 0 8px 15px rgba(0,0,0,0.2); transition: 0.1s; border-top: 1px solid #666;
        }
        .btn-modal-safe:active { transform: translateY(4px); box-shadow: 0 0 0 #000, inset 0 2px 5px rgba(0,0,0,0.4); }
        
        .btn-modal-danger { 
            background: linear-gradient(180deg, #ffffff 0%, #ffe6eb 100%); color: #b90038; border: 1px solid #ffb3c1; border-top: 1px solid #fff;
            padding: 14px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; flex: 1; 
            box-shadow: 0 4px 0 #e68a9d, 0 8px 15px rgba(185,0,56,0.1); transition: 0.1s;
        }
        .btn-modal-danger:active { transform: translateY(4px); box-shadow: 0 0 0 #e68a9d, inset 0 2px 5px rgba(185,0,56,0.2); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="trips-container">
        
        <asp:HiddenField ID="hfCancelBid" runat="server" />
        <asp:LinkButton ID="lnkConfirmCancel" runat="server" OnClick="btnConfirmCancel_Click" style="display: none;"></asp:LinkButton>

        <div class="page-title">Your Journeys</div>

        <div class="section-title">Upcoming reservations</div>
        <div class="trip-grid">
            <asp:Repeater ID="rptUpcoming" runat="server">
                <ItemTemplate>
                    <div class="trip-card">
                        <img src='<%# GetImage(Eval("pimage")) %>' class="trip-img" alt="Property" />
                        <div class="trip-info">
                            <div class="trip-location"><%# Eval("title") %></div>
                            <div class="trip-dates"><%# Convert.ToDateTime(Eval("checkindate")).ToString("MMM dd") %> - <%# Convert.ToDateTime(Eval("checkoutdate")).ToString("MMM dd, yyyy") %></div>
                            <div><span class="trip-status status-upcoming">Confirmed</span></div>
                            
                            <div class="trip-footer">
                                <span class="trip-price">&#8377;<%# Convert.ToDecimal(Eval("totalamount")).ToString("N0") %></span>
                                
                                <div class="action-links">
                                    <a href='customerpropertydetail.aspx?pid=<%# Eval("pid") %>' class="view-details-link">View details</a>
                                    
                                    <asp:LinkButton ID="lnkMsgHostUpcoming" runat="server" 
                                        CssClass="msg-host-btn"
                                        CommandName="MessageHost"
                                        CommandArgument='<%# Eval("hid") + "|" + Eval("pid") %>'
                                        OnCommand="lnkMessageHost_Command">
                                        <i class="fas fa-comment-dots"></i> Message Host
                                    </asp:LinkButton>

                                    <asp:Button ID="btnPreCancel" runat="server" Text="Cancel Trip" 
                                        CssClass="cancel-btn"
                                        Visible='<%# Convert.ToDateTime(Eval("checkindate")).Subtract(DateTime.Now).TotalDays >= 2 %>'
                                        OnClientClick='<%# "showCancelWarning(\"" + Eval("bid") + "\"); return false;" %>' />
                                    
                                    <asp:Label ID="lblNoCancel" runat="server" style="color: #b90038; font-size: 12px; font-weight: 700;"
                                        Visible='<%# Convert.ToDateTime(Eval("checkindate")).Subtract(DateTime.Now).TotalDays < 2 %>'>
                                        Cancellation closed
                                    </asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <asp:Label ID="lblNoUpcoming" runat="server" Visible="false">
            <div class="empty-state">
                <i class="fas fa-suitcase empty-icon"></i>
                <div style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 22px; font-weight: 800; color: #2d2f2f;">No trips booked... yet!</div>
                <div style="color: #5a5c5c; margin-top: 12px; font-size: 16px;">Time to dust off your bags and start planning your next adventure.</div>
            </div>
        </asp:Label>

        <div style="height: 60px;"></div>

        <div class="section-title">Current stays</div>
        <div class="trip-grid">
            <asp:Repeater ID="rptCurrent" runat="server">
                <ItemTemplate>
                    <div class="trip-card">
                        <img src='<%# GetImage(Eval("pimage")) %>' class="trip-img" alt="Property" />
                        <div class="trip-info">
                            <div class="trip-location"><%# Eval("title") %></div>
                            <div class="trip-dates"><%# Convert.ToDateTime(Eval("checkindate")).ToString("MMM dd") %> - <%# Convert.ToDateTime(Eval("checkoutdate")).ToString("MMM dd, yyyy") %></div>
                            <div><span class="trip-status status-current">Checked In</span></div>
                            
                            <div class="trip-footer">
                                <span class="trip-price">&#8377;<%# Convert.ToDecimal(Eval("totalamount")).ToString("N0") %></span>
                                
                                <div class="action-links">
                                    <a href='customerpropertydetail.aspx?pid=<%# Eval("pid") %>' class="view-details-link">View details</a>

                                    <asp:LinkButton ID="lnkMsgHostCurrent" runat="server" 
                                        CssClass="msg-host-btn"
                                        CommandName="MessageHost"
                                        CommandArgument='<%# Eval("hid") + "|" + Eval("pid") %>'
                                        OnCommand="lnkMessageHost_Command">
                                        <i class="fas fa-comment-dots"></i> Message Host
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <asp:Label ID="lblNoCurrent" runat="server" Visible="false">
            <div style="color: #5a5c5c; font-weight: 500; font-size: 16px; padding-left: 10px;">You have no current active stays.</div>
        </asp:Label>

        <div style="height: 60px;"></div>

        <div class="section-title">Where you've been</div>
        <div class="trip-grid">
            <asp:Repeater ID="rptPast" runat="server">
                <ItemTemplate>
                    <div class="trip-card">
                        <div style="position:relative;">
                            <img src='<%# GetImage(Eval("pimage")) %>' class="trip-img" style="filter: grayscale(30%) brightness(0.9);" alt="Property" />
                            <div style="position:absolute; inset:0; background: rgba(255,255,255,0.1); border-radius: 16px;"></div>
                        </div>
                        <div class="trip-info">
                            <div class="trip-location"><%# Eval("title") %></div>
                            <div class="trip-dates"><%# Convert.ToDateTime(Eval("checkindate")).ToString("MMM dd") %> - <%# Convert.ToDateTime(Eval("checkoutdate")).ToString("MMM dd, yyyy") %></div>
                            <div><span class="trip-status status-past">Completed</span></div>
                            
                            <div class="trip-footer">
                                <span class="trip-price">&#8377;<%# Convert.ToDecimal(Eval("totalamount")).ToString("N0") %></span>
                                
                                <div class="action-links">
                                    <a href='customerpropertydetail.aspx?pid=<%# Eval("pid") %>' class="view-details-link">Book again</a>
                                    
                                    <asp:HyperLink ID="hlReview" runat="server" 
                                        NavigateUrl='<%# "customerreview.aspx?pid=" + Eval("pid") + "&bid=" + Eval("bid") %>' 
                                        CssClass="review-btn" 
                                        Visible='<%# Convert.ToInt32(Eval("HasReviewed")) == 0 %>'>
                                        Leave a review
                                    </asp:HyperLink>

                                    <asp:Label ID="lblReviewed" runat="server" 
                                        style="color: #00A699; font-size: 13px; font-weight: 700;"
                                        Visible='<%# Convert.ToInt32(Eval("HasReviewed")) > 0 %>'>
                                        <i class="fas fa-check-circle"></i> Reviewed
                                    </asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <asp:Label ID="lblNoPast" runat="server" Visible="false">
            <div style="color: #5a5c5c; font-weight: 500; font-size: 16px; padding-left: 10px;">You have no past trips.</div>
        </asp:Label>

    </div>

    <div id="warningModal" class="modal-overlay">
        <div class="modal-box">
            <i class="fas fa-exclamation-triangle modal-icon-warning"></i>
            <div class="modal-title">Cancel Reservation?</div>
            <div class="modal-text">Are you sure you want to cancel this trip? This action cannot be undone and your host will be notified immediately.</div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-safe" onclick="hideCancelWarning()">Never mind</button>
                <button type="button" class="btn-modal-danger" onclick="executeServerCancel()">Yes, cancel trip</button>
            </div>
        </div>
    </div>

    <div id="successModal" class="modal-overlay">
        <div class="modal-box">
            <i class="fas fa-check-circle modal-icon-success"></i>
            <div class="modal-title">Trip Cancelled</div>
            <div class="modal-text">Your reservation has been successfully cancelled. The dates have been released.</div>
            <button type="button" class="btn-modal-safe" style="width: 100%;" onclick="closeSuccessAndRefresh()">Close</button>
        </div>
    </div>

    <script>
        function showCancelWarning(bid) {
            document.getElementById('<%= hfCancelBid.ClientID %>').value = bid;
            document.getElementById('warningModal').classList.add('show');
        }

        function hideCancelWarning() {
            document.getElementById('warningModal').classList.remove('show');
        }

        function executeServerCancel() {
            hideCancelWarning();
            __doPostBack('<%= lnkConfirmCancel.UniqueID %>', '');
        }

        function showCancelSuccess() {
            document.getElementById('successModal').classList.add('show');
        }

        function closeSuccessAndRefresh() {
            document.getElementById('successModal').classList.remove('show');
            window.location.href = 'customertrips.aspx';
        }
    </script>
</asp:Content>