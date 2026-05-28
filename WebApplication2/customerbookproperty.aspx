<%@ Page Title="Confirm Booking" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customerbookproperty.aspx.cs" Inherits="WebApplication2.customerbookproperty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    
    <style>
        /* HIDE LOGO HACK */
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        /* --- LUMINOUS EDITORIAL BACKGROUND --- */
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

        h1, h2, h3, .font-headline { font-family: 'Plus Jakarta Sans', sans-serif; }

        /* --- LAYOUT --- */
        .booking-container { max-width: 1200px; margin: 60px auto 100px auto; padding: 0 40px; }
        
        .page-title { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            font-size: 3rem; 
            font-weight: 800; 
            margin-bottom: 40px; 
            letter-spacing: -0.05em; 
            color: #2d2f2f;
            text-shadow: 1px 1px 0px rgba(255,255,255,0.8);
        }
        
        .flex-layout { display: flex; gap: 80px; flex-wrap: wrap; }
        .left-col { flex: 1; min-width: 320px; }
        .right-col { width: 420px; }

        /* --- LEFT SIDE STYLES --- */
        .section-title { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            font-size: 1.8rem; 
            font-weight: 800; 
            margin-bottom: 24px; 
            letter-spacing: -0.02em; 
        }
        
        .trip-details { display: flex; justify-content: space-between; margin-bottom: 24px; }
        .detail-label { font-weight: 700; font-size: 18px; color: #2d2f2f; }
        .detail-value { color: #5a5c5c; font-size: 16px; margin-top: 6px; font-weight: 500; }
        
        .divider { 
            height: 1px; 
            background: rgba(0,0,0,0.08); 
            margin: 40px 0; 
            box-shadow: 0 1px 0 rgba(255,255,255,0.6);
        }

        /* --- GLASSMORPHISM PANELS --- */
        .glass-panel {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.7) 0%, rgba(255, 255, 255, 0.3) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            -webkit-backdrop-filter: blur(25px) saturate(120%);
            border-top: 1.5px solid rgba(255, 255, 255, 0.9);
            border-left: 1.5px solid rgba(255, 255, 255, 0.9);
            border-bottom: 1.5px solid rgba(0, 0, 0, 0.05);
            border-right: 1.5px solid rgba(0, 0, 0, 0.05);
            border-radius: 2rem;
            box-shadow: 10px 10px 30px rgba(0,0,0,0.06), inset 2px 2px 10px rgba(255, 255, 255, 0.5);
            padding: 32px;
        }

        .login-prompt-card { 
            display: flex; justify-content: space-between; align-items: center; 
            gap: 20px;
        }

        /* --- BUTTONS --- */
        .btn-glass-outline { 
            background: rgba(255,255,255,0.4); 
            border: 1px solid rgba(255,255,255,0.8); 
            color: #222; padding: 12px 24px; 
            border-radius: 12px; font-weight: 700; 
            text-decoration: none; cursor: pointer; 
            transition: all 0.2s; white-space: nowrap;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .btn-glass-outline:hover { 
            background: rgba(255,255,255,0.8); transform: translateY(-2px);
        }

        .btn-glass-primary { 
            background: linear-gradient(180deg, #FA4871 0%, #D70466 100%);
            color: white; border: 1px solid #A8004E; border-top: 1px solid #FF8AA9;
            padding: 16px; border-radius: 16px; font-weight: 700; font-size: 18px; 
            font-family: 'Plus Jakarta Sans', sans-serif;
            width: 100%; cursor: pointer; margin-top: 24px;
            box-shadow: 0 6px 0 #A8004E, 0 12px 20px rgba(230, 30, 77, 0.3);
            transition: all 0.1s ease; text-shadow: 0 -1px 0 rgba(0,0,0,0.2);
        }
        .btn-glass-primary:active { 
            transform: translateY(6px); 
            box-shadow: 0 0 0 #A8004E, inset 0 4px 8px rgba(0,0,0,0.4); 
        }

        /* --- RIGHT SIDE SUMMARY CARD --- */
        .summary-card { 
            position: sticky; top: 140px; /* Accounts for the master header */
        }
        
        .prop-header { 
            display: flex; gap: 20px; margin-bottom: 32px; 
            border-bottom: 1px solid rgba(0,0,0,0.08); 
            padding-bottom: 32px; 
            box-shadow: 0 1px 0 rgba(255,255,255,0.5);
        }
        
        .prop-thumb { 
            width: 120px; height: 110px; border-radius: 16px; object-fit: cover; 
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            border: 2px solid rgba(255,255,255,0.6);
        }
        
        .prop-title { font-size: 13px; color: #5a5c5c; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; }
        .prop-name { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 800; margin-top: 6px; line-height: 1.2; color: #2d2f2f; letter-spacing: -0.02em; }
        
        .price-row { display: flex; justify-content: space-between; margin-bottom: 16px; font-size: 16px; color: #5a5c5c; font-weight: 500; }
        .price-row span { color: #2d2f2f; }
        
        .price-total { 
            display: flex; justify-content: space-between; margin-top: 24px; padding-top: 24px; 
            border-top: 1px solid rgba(0,0,0,0.08); box-shadow: inset 0 1px 0 rgba(255,255,255,0.5);
            font-weight: 800; font-size: 20px; font-family: 'Plus Jakarta Sans', sans-serif; color: #2d2f2f; 
        }

        @media (max-width: 900px) {
            .flex-layout { gap: 40px; flex-direction: column-reverse; }
            .right-col { width: 100%; }
            .summary-card { position: static; }
            .booking-container { padding: 0 20px; margin-top: 30px; }
            .page-title { font-size: 2.2rem; margin-bottom: 20px; }
            .login-prompt-card { flex-direction: column; align-items: flex-start; }
            .btn-glass-outline { width: 100%; text-align: center; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="booking-container">
        <div class="page-title">
            <asp:Label ID="lblMainTitle" runat="server" Text="Request to book"></asp:Label>
        </div>

        <div class="flex-layout">
            <div class="left-col">
                <div class="section-title">Your trip</div>
                
                <div class="trip-details">
                    <div>
                        <div class="detail-label">Dates</div>
                        <div class="detail-value"><asp:Label ID="lblDates" runat="server"></asp:Label></div>
                    </div>
                </div>

                <div class="trip-details">
                    <div>
                        <div class="detail-label">Guests</div>
                        <div class="detail-value"><asp:Label ID="lblGuestCount" runat="server"></asp:Label></div>
                    </div>
                </div>

                <div class="divider"></div>

                <asp:Panel ID="pnlGuestView" runat="server">
                    <div class="section-title">Log in or sign up to book</div>
                    <div class="glass-panel login-prompt-card">
                        <div>
                            <div style="font-weight: 700; font-size: 18px; font-family: 'Plus Jakarta Sans', sans-serif; color: #2d2f2f;">You must be logged in</div>
                            <div style="color: #5a5c5c; font-size: 15px; margin-top: 6px; font-weight: 500;">Log in to confirm your trip details and pay.</div>
                        </div>
                        <div>
                            <asp:Button ID="btnLoginRedirect" runat="server" Text="Log in" CssClass="btn-glass-outline" OnClick="btnLoginRedirect_Click" />
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlAuthView" runat="server" Visible="false">
                    <div class="section-title">Payment</div>
                    <div class="glass-panel">
                        <p style="color: #5a5c5c; font-size: 16px; font-weight: 500; margin-bottom: 0;">You are logged in securely. Click the button below to proceed to the secure payment gateway to complete your reservation.</p>
                        <asp:Button ID="btnProceedToPay" runat="server" Text="Confirm and Pay" CssClass="btn-glass-primary" OnClick="btnProceedToPay_Click" />
                    </div>
                </asp:Panel>
            </div>

            <div class="right-col">
                <div class="glass-panel summary-card">
                    <div class="prop-header">
                        <asp:Image ID="imgProperty" runat="server" CssClass="prop-thumb" />
                        <div>
                            <div class="prop-title">Entire home</div>
                            <div class="prop-name"><asp:Label ID="lblPropName" runat="server"></asp:Label></div>
                        </div>
                    </div>

                    <div class="section-title" style="font-size: 1.4rem; margin-top: 0; margin-bottom: 24px;">Price details</div>
                    
                    <div class="price-row">
                        <div><asp:Label ID="lblCalculation" runat="server"></asp:Label></div>
                        <span>₹<asp:Label ID="lblBaseTotal" runat="server"></asp:Label></span>
                    </div>
                    
                    <div class="price-row">
                        <div style="text-decoration: underline; text-decoration-color: rgba(0,0,0,0.3); text-underline-offset: 2px;">Housie service fee</div>
                        <span>₹<asp:Label ID="lblServiceFee" runat="server">500</asp:Label></span>
                    </div>

                    <div class="price-total">
                        <div>Total (INR)</div>
                        <div>₹<asp:Label ID="lblGrandTotal" runat="server"></asp:Label></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>