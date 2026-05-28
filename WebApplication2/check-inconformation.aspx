<%@ Page Title="Today's Check-ins" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="check-inconformation.aspx.cs" Inherits="WebApplication2.check_inconformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f7f7;
            background-image: linear-gradient(135deg, rgba(255, 255, 255, 0.4) 0%, rgba(255, 255, 255, 0.1) 100%), url('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=1920&auto=format&fit=crop') !important;
            background-size: cover !important;
            background-attachment: fixed !important;
            color: #2d2f2f;
        }

        .glass-panel {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0.4) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            -webkit-backdrop-filter: blur(25px) saturate(120%);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 1.5rem;
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 20px;
        }

        .page-title {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-weight: 800;
            font-size: 28px;
            color: #1e293b;
            margin-bottom: 5px;
        }

        /* Booking Card Styles */
        .booking-card {
            display: flex;
            align-items: center;
            background: white;
            border-radius: 1rem;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s;
            gap: 20px;
            flex-wrap: wrap;
        }
        .booking-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }

        .guest-avatar {
            width: 70px;
            height: 70px;
            background: #e2e8f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #64748b;
        }

        .booking-details { flex: 1; min-width: 250px; }
        .guest-name { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 800; margin-bottom: 4px; color: #0f172a; }
        .guest-info { font-size: 14px; color: #64748b; margin-bottom: 8px; font-weight: 500; }
        .property-name { font-size: 15px; font-weight: 700; color: #3b82f6; display: flex; align-items: center; gap: 6px; }

        .date-box {
            background: #f8fafc;
            padding: 10px 15px;
            border-radius: 10px;
            text-align: center;
            border: 1px solid #e2e8f0;
            min-width: 120px;
        }
        .date-label { font-size: 11px; text-transform: uppercase; font-weight: 700; color: #94a3b8; margin-bottom: 2px; }
        .date-value { font-size: 15px; font-weight: 700; color: #334155; }

        .btn-checkin {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            white-space: nowrap;
        }
        .btn-checkin:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4); color: white; }

        .empty-state { text-align: center; padding: 50px 20px; }
        .empty-state i { font-size: 50px; color: #cbd5e1; margin-bottom: 15px; }
        .empty-state h4 { font-weight: 800; color: #475569; }
        
        @media (max-width: 768px) {
            .booking-card { flex-direction: column; align-items: flex-start; }
            .guest-avatar { display: none; }
            .btn-checkin { width: 100%; justify-content: center; mt-3; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5 mb-5">
        <div class="glass-panel">
            <h1 class="page-title">Today's Check-ins</h1>
            <p style="color: #64748b; font-weight: 500; margin-bottom: 30px;">
                Review and confirm guests arriving at your properties today.
            </p>

            <asp:Repeater ID="rptCheckins" runat="server" OnItemCommand="rptCheckins_ItemCommand">
                <ItemTemplate>
                    <div class="booking-card">
                        <div class="guest-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        
                        <div class="booking-details">
                            <div class="guest-name"><%# Eval("CustomerName") %></div>
                            <div class="guest-info">
                                <i class="fas fa-phone-alt me-1"></i> <%# Eval("phoneno") %> &nbsp;|&nbsp; 
                                <i class="fas fa-users me-1"></i> <%# Eval("guestcount") %> Guests
                            </div>
                            <div class="property-name">
                                <i class="fas fa-home"></i> <%# Eval("title") %>
                            </div>
                        </div>

                        <div class="date-box">
                            <div class="date-label">Check-In</div>
                            <div class="date-value"><%# Convert.ToDateTime(Eval("checkindate")).ToString("MMM dd, yyyy") %></div>
                        </div>
                        
                        <div class="date-box">
                            <div class="date-label">Check-Out</div>
                            <div class="date-value"><%# Convert.ToDateTime(Eval("checkoutdate")).ToString("MMM dd, yyyy") %></div>
                        </div>

                        <div>
                            <asp:LinkButton ID="btnConfirmCheckIn" runat="server" 
                                CssClass="btn-checkin" 
                                CommandName="ConfirmCheckIn" 
                                CommandArgument='<%# Eval("bid") %>'>
                                <i class="fas fa-check-circle"></i> Confirm Check-in
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoCheckins" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-calendar-check"></i>
                <h4>All caught up!</h4>
                <p>There are no guests scheduled to check in today, or they have all been confirmed.</p>
            </asp:Panel>

        </div>
    </div>
</asp:Content>