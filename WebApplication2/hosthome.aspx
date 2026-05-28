<%@ Page Title="My Properties" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hosthome.aspx.cs" Inherits="WebApplication2.hosthome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        /* HIDE LOGO HACK */
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        /* --- 1. Luminous Background --- */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f7f7;
            background-image: linear-gradient(135deg, rgba(255, 255, 255, 0.4) 0%, rgba(255, 255, 255, 0.1) 100%), url('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=1920&auto=format&fit=crop') !important;
            background-size: cover !important;
            background-attachment: fixed !important;
            background-position: center !important;
            color: #2d2f2f;
            overflow-x: hidden; 
        }

        h1, h2, h3, h4, h5 { font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; padding: 0; }

        .dashboard-container {
            width: 100vw;
            position: relative;
            left: 50%;
            right: 50%;
            margin-left: -50vw;
            margin-right: -50vw;
            padding: 40px 2vw; 
            box-sizing: border-box;
        }

        /* --- 2. Reusable Glass Panel --- */
        .glass-panel {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.65) 0%, rgba(255, 255, 255, 0.25) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            -webkit-backdrop-filter: blur(25px) saturate(120%);
            border-top: 1.5px solid rgba(255, 255, 255, 0.9);
            border-left: 1.5px solid rgba(255, 255, 255, 0.9);
            border-bottom: 1.5px solid rgba(0, 0, 0, 0.05);
            border-right: 1.5px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 15px 35px rgba(0,0,0,0.08), inset 2px 2px 10px rgba(255,255,255,0.5);
        }

        /* --- 3. Sidebar Styles --- */
        .sidebar-card {
            border-radius: 2rem;
            padding: 30px 20px;
            height: 100%;
            min-height: 80vh;
        }

        .sidebar-title {
            font-weight: 800;
            font-size: 20px;
            color: #2d2f2f;
            margin-bottom: 30px;
            padding-left: 10px;
            letter-spacing: -0.02em;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 14px 20px;
            color: #5a5c5c;
            text-decoration: none;
            border-radius: 16px;
            margin-bottom: 8px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-weight: 700;
            font-size: 15px;
            border: 1px solid transparent;
        }

        .nav-link-custom i {
            width: 28px;
            font-size: 1.2rem;
            margin-right: 12px;
            color: #8c8c8c;
            transition: 0.3s;
        }

        .nav-link-custom:hover {
            background: rgba(255, 255, 255, 0.6);
            color: #b90038;
            transform: translateX(6px);
            border-color: rgba(255,255,255,0.8);
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }

        .nav-link-custom:hover i { color: #b90038; }

        .nav-link-custom.active {
            background: linear-gradient(135deg, #FA4871 0%, #D70466 100%);
            color: white;
            box-shadow: 0 8px 20px rgba(230, 30, 77, 0.3), inset 1px 1px 2px rgba(255,255,255,0.4);
            border-color: transparent;
        }

        .nav-link-custom.active i { color: white; }

        /* --- 4. Top Bar --- */
        .top-bar-glass {
            border-radius: 1.5rem;
            padding: 20px 30px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-bar-title {
            font-weight: 800;
            font-size: 24px;
            color: #2d2f2f;
            letter-spacing: -0.02em;
        }

        /* --- 5. Buttons --- */
        .btn-glass-primary {
            background: linear-gradient(180deg, #FA4871 0%, #D70466 100%);
            color: white;
            border: 1px solid #A8004E;
            border-top: 1px solid #FF8AA9;
            padding: 10px 24px;
            border-radius: 999px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 15px;
            cursor: pointer;
            box-shadow: 0 4px 0 #A8004E, 0 8px 15px rgba(230, 30, 77, 0.3);
            transition: all 0.1s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .btn-glass-primary:hover { color: white; filter: brightness(1.05); }
        .btn-glass-primary:active { transform: translateY(4px); box-shadow: 0 0 0 #A8004E, inset 0 2px 5px rgba(0,0,0,0.4); }

        .btn-glass-outline {
            background: linear-gradient(180deg, #ffffff 0%, #f0f0f0 100%);
            border: 1px solid #ccc;
            border-top: 1px solid #fff;
            color: #2d2f2f;
            padding: 8px 20px;
            border-radius: 999px;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            text-decoration: none;
            box-shadow: 0 4px 0 #b3b3b3, 0 6px 10px rgba(0,0,0,0.05);
            transition: all 0.1s ease;
            display: inline-block;
        }
        .btn-glass-outline:hover { background: #fff; color: #2d2f2f; }
        .btn-glass-outline:active { transform: translateY(4px); box-shadow: 0 0 0 #b3b3b3, inset 0 2px 5px rgba(0,0,0,0.1); }

        .btn-glass-danger {
            background: #fff;
            border: 1px solid #E61E4D;
            color: #E61E4D;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            text-decoration: none;
            box-shadow: 0 4px 0 #b90038, 0 6px 10px rgba(230, 30, 77, 0.1);
            transition: all 0.1s ease;
            display: inline-block;
        }
        .btn-glass-danger:hover { background: #fff0f2; color: #E61E4D; }
        .btn-glass-danger:active { transform: translateY(4px); box-shadow: 0 0 0 #b90038, inset 0 2px 5px rgba(0,0,0,0.1); }

        .action-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        /* --- 6. Property Card Styles --- */
        .property-card {
            border-radius: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            height: 100%;
            margin-bottom: 20px; 
            position: relative;
        }

        .property-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12), inset 2px 2px 10px rgba(255,255,255,0.6);
        }

        /* UNLISTED CARD STYLING */
        .unlisted-card {
            opacity: 0.7;
            border: 1px solid rgba(230, 30, 77, 0.8) !important;
            box-shadow: inset 0 0 0 1px rgba(230, 30, 77, 0.3);
        }
        
        /* FLAGGED CARD STYLING */
        .flagged-card {
            border: 1px solid #E61E4D !important;
            box-shadow: 0 0 15px rgba(230, 30, 77, 0.2), inset 0 0 0 1px #E61E4D;
        }

        .unlisted-badge {
            position: absolute;
            top: 20px;
            left: 20px;
            background: linear-gradient(135deg, #FA4871 0%, #D70466 100%);
            color: white;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            z-index: 10;
            box-shadow: 0 4px 10px rgba(230, 30, 77, 0.4);
            border: 1px solid #FF8AA9;
        }
        
        .flagged-badge {
            background: #E61E4D;
            border-color: #b90038;
        }

        .prop-img-container {
            height: 220px;
            margin: 12px 12px 0 12px;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: inset 2px 2px 5px rgba(0,0,0,0.1);
        }

        .prop-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .property-card:hover .prop-img { transform: scale(1.05); }

        .prop-details { padding: 20px 16px; display: flex; flex-direction: column; flex: 1; }

        .prop-title-text {
            font-size: 18px;
            font-weight: 800;
            color: #222222;
            margin-bottom: 6px;
            line-height: 1.3;
        }

        .prop-location {
            color: #5a5c5c;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 16px;
        }

        .prop-footer {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid rgba(0,0,0,0.06);
            padding-top: 16px;
        }

        .prop-price {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 18px; 
            font-weight: 800;
            color: #222222;
        }

        /* --- 7. Empty State --- */
        .empty-state {
            border-radius: 2rem;
            padding: 60px 40px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .empty-state h4 { font-size: 24px; font-weight: 800; margin-bottom: 12px; color: #2d2f2f; }
        .empty-state p { color: #5a5c5c; font-size: 16px; font-weight: 500; margin-bottom: 24px; }

        @media (min-width: 1400px) {
            .sidebar-col { width: 250px; flex: 0 0 250px; }
            .content-col { flex: 1; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dashboard-container">
        <div class="row g-4">
            
            <div class="col-md-4 col-lg-3 sidebar-col">
                <div class="glass-panel sidebar-card">
                    <h4 class="sidebar-title">Host Menu</h4>
                    <a href="hosthome.aspx" class="nav-link-custom active"><i class="fas fa-home"></i> My Properties</a>
                    <a href="add_property.aspx" class="nav-link-custom"><i class="fas fa-plus-circle"></i> Add Property</a>
                    <a href="hostbooking.aspx" class="nav-link-custom"><i class="fas fa-calendar-alt"></i> Bookings</a>
                    <a href="hostPayments.aspx" class="nav-link-custom"><i class="fas fa-wallet"></i> Earnings</a>
                    <a href="hostrating.aspx" class="nav-link-custom"><i class="fas fa-star"></i> Reviews</a>
                    <a href="check-inconformation.aspx" class="nav-link-custom"><i class="fas fa-sign-in-alt"></i> Check-ins</a>
                    <a href="checkout_conformation.aspx" class="nav-link-custom"><i class="fas fa-sign-out-alt"></i> Check-outs</a>
                    <a href="hostmessages.aspx" class="nav-link-custom" style="justify-content:space-between;">
                        <span><i class="fas fa-comment-dots"></i> Messages</span>
                        <asp:Label ID="lblSidebarUnreadBadge" runat="server" Visible="false"
                            style="background:linear-gradient(135deg,#E61E4D,#D70466);color:white;font-size:11px;font-weight:800;padding:3px 8px;border-radius:20px;box-shadow:0 2px 6px rgba(230,30,77,.4);">
                        </asp:Label>
                    </a>
                </div>
            </div>

            <div class="col-md-8 col-lg-9 content-col">
                
                <div class="glass-panel top-bar-glass">
                    <h3 class="top-bar-title">My Listed Properties</h3>
                    <a href="add_property.aspx" class="btn-glass-primary">
                        <i class="fas fa-plus me-2"></i> Add New
                    </a>
                </div>

                <div class="row g-4">
                    <asp:Repeater ID="rptProperties" runat="server" OnItemCommand="rptProperties_ItemCommand">
                        <ItemTemplate>
                            <div class="col-12 col-md-6 col-lg-4 col-xl-3">
                                
                                <%-- Evaluates status to add specific CSS classes --%>
                                <div class='glass-panel property-card <%# Eval("status").ToString() == "6" ? "unlisted-card" : (Eval("status").ToString() == "4" ? "flagged-card" : "") %>'>
                                    
                                    <%-- Badges --%>
                                    <%# Eval("status").ToString() == "6" ? "<div class='unlisted-badge'>Unlisted</div>" : "" %>
                                    <%# Eval("status").ToString() == "4" ? "<div class='unlisted-badge flagged-badge'><i class='fas fa-flag'></i> Flagged</div>" : "" %>

                                    <div class="prop-img-container">
                                        <img src='<%# Eval("pimage") != DBNull.Value && !string.IsNullOrEmpty(Eval("pimage").ToString()) ? ResolveUrl("~/" + Eval("pimage").ToString()) : "https://via.placeholder.com/600x400" %>' class="prop-img" />
                                    </div>
                                    <div class="prop-details">
                                        <h5 class="prop-title-text"><%# Eval("title") %></h5>
                                        <div class="prop-location"><i class="fas fa-map-marker-alt me-1 text-danger"></i> <%# Eval("address") %></div>
                                        
                                        <div class="prop-footer">
                                            <div class="prop-price">
                                                &#8377;<%# Eval("price", "{0:N0}") %><span style="font-size:13px; font-weight:500; color:#5a5c5c;"> /nt</span>
                                            </div>
                                            
                                            <div class="action-group">
                                                
                                                <%-- List/Unlist Button (Hidden if Flagged) --%>
                                                <asp:LinkButton ID="btnToggleStatus" runat="server" 
                                                    CssClass="btn-glass-outline" 
                                                    style="padding: 6px 12px; font-size: 13px;"
                                                    CommandName="ToggleStatus" 
                                                    CommandArgument='<%# Eval("pid") %>'
                                                    Visible='<%# Eval("status").ToString() == "2" || Eval("status").ToString() == "6" %>'>
                                                    <%# Eval("status").ToString() == "2" ? "<i class='fas fa-eye-slash me-1'></i> Unlist" : "<i class='fas fa-eye me-1'></i> List" %>
                                                </asp:LinkButton>

                                                <a href='edithostproperty.aspx?pid=<%# Eval("pid") %>' class="btn-glass-outline" style="padding: 6px 12px; font-size: 13px;">
                                                    <i class="fas fa-edit me-1"></i> Edit
                                                </a>

                                                <%-- NEW FLAGGED INDICATOR / BUTTON --%>
                                                <%# Eval("status").ToString() == "4" ? "<a href='flagproperty.aspx?pid=" + Eval("pid") + "' class='btn-glass-danger' title='View Reason'><i class='fas fa-exclamation-triangle'></i></a>" : "" %>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoProperties" runat="server" Visible="false" CssClass="col-12">
                        <div class="glass-panel empty-state">
                            <i class="fas fa-folder-open fa-4x mb-4" style="color: rgba(230, 30, 77, 0.4); filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));"></i>
                            <h4>No properties found!</h4>
                            <p>You haven't listed any properties yet.</p>
                            <a href="add_property.aspx" class="btn-glass-primary">Get Started</a>
                        </div>
                    </asp:Panel>
                </div>

            </div>
        </div>
    </div>
</asp:Content>