<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminhomepage.aspx.cs" Inherits="WebApplication2.adminhomepage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- Styles --- */
        .welcome-banner {
            background: linear-gradient(90deg, #E61E4D 0%, #ff8a65 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 20px rgba(230, 30, 77, 0.2);
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 800;
            color: #333;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.95rem;
            font-weight: 500;
            margin-bottom: 20px;
        }
    </style></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="welcome-banner">
        <h1 class="fw-bold display-6">Welcome back, Admin!</h1>
        <p class="mb-0 opacity-75">Here is a quick overview of what's happening on Housie today.</p>
        
        <a href="adminappeals.aspx" class="nav-link" style="color:white; margin-top:10px; display:inline-block;">
            Messages 
            <asp:Panel ID="pnlNotification" runat="server" Visible="false" 
                style="display:inline-block; background:#E61E4D; color:white; border-radius:50%; width:18px; height:18px; font-size:10px; text-align:center; line-height:18px;">
                !
            </asp:Panel>
        </a>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="stat-card" style="border-top: 5px solid #E61E4D;">
                <div>
                    <i class="bi bi-person-check stat-icon" style="color: #E61E4D;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litHostCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Pending Host Approvals</div>
                </div>
                <a href="hostapprovel.aspx" class="btn btn-outline-danger w-100 rounded-pill">Review Host Requests</a>
            </div>
        </div>

        <div class="col-md-6">
            <div class="stat-card" style="border-top: 5px solid #f59e0b;">
                <div>
                    <i class="bi bi-house-check stat-icon" style="color: #f59e0b;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litPendingPropertyCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Pending Property Approvals</div>
                </div>
                <a href="VerifyProperties.aspx" class="btn btn-outline-warning w-100 rounded-pill">Review Property Listings</a>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div>
                    <i class="bi bi-grid stat-icon" style="color: #6c757d;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litCategoryCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Property Categories</div>
                </div>
                <a href="propertytype.aspx" class="btn btn-outline-secondary w-100 rounded-pill">Manage Types</a>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="stat-card">
                <div>
                    <i class="bi bi-geo-alt stat-icon" style="color: #6c757d;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litLocationCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Active Districts</div>
                </div>
                <a href="district.aspx" class="btn btn-outline-secondary w-100 rounded-pill">View Districts</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div>
                    <i class="bi bi-houses stat-icon" style="color: #2563eb;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litPropertyCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Total Published Properties</div>
                </div>
                <a href="adminviewallproperty.aspx" class="btn btn-outline-primary w-100 rounded-pill">View All Data</a>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #059669;">
                <div>
                    <i class="bi bi-people stat-icon" style="color: #059669;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litActiveHostCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Verified Active Hosts</div>
                </div>
                <a href="activehost.aspx" class="btn btn-outline-success w-100 rounded-pill">Manage All Hosts</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #0dcaf0;">
                <div>
                    <i class="bi bi-chat-heart stat-icon" style="color: #0dcaf0;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litTotalReviewCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Total Property Reviews</div>
                </div>
                <a href="adminreview.aspx" class="btn btn-outline-info w-100 rounded-pill">Moderate Reviews</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #198754;">
                <div>
                    <i class="bi bi-credit-card stat-icon" style="color: #198754;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litPaymentCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Recent Payments</div>
                </div>
                <a href="adminpayment.aspx" class="btn btn-outline-success w-100 rounded-pill">View Payments</a>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #dc3545;">
                <div>
                    <i class="bi bi-star-half stat-icon" style="color: #dc3545;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litLowReviewCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Properties with Low Reviews (&le; 2)</div>
                </div>
                <a href="adminlowrating.aspx" class="btn btn-outline-danger w-100 rounded-pill">Review Properties</a>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #6c757d;">
                <div>
                    <i class="bi bi-chat-dots stat-icon" style="color: #6c757d;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litFeedbackCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Reports</div>
                </div>
                <a href="adminreport.aspx" class="btn btn-outline-secondary w-100 rounded-pill">View Reports</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #8b5cf6;">
                <div>
                    <i class="bi bi-envelope-exclamation stat-icon" style="color: #8b5cf6;"></i>
                    <div class="stat-number">
                        <asp:Literal ID="litAppealsCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Property Appeals / Messages</div>
                </div>
                <a href="adminappeals.aspx" class="btn btn-outline-primary w-100 rounded-pill" style="border-color: #8b5cf6; color: #8b5cf6;">View Messages</a>
            </div>
        </div>
    </div>
    
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card" style="border-bottom: 5px solid #6366f1;">
                <div>
                    <i class="bi bi-person-badge stat-icon" style="color: #6366f1;"></i>
                    <div class="stat-number">
                        All Hosts
                    </div>
                    <div class="stat-label">Complete Platform Directory</div>
                </div>
                <a href="adminm.aspx" class="btn btn-outline-primary w-100 rounded-pill" style="border-color: #6366f1; color: #6366f1;">View Directory</a>
            </div>
        </div>
    </div>
</asp:Content>
