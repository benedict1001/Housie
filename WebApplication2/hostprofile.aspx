<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hostprofile.aspx.cs" Inherits="WebApplication2.hostprofile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- HOUSIE THEME STYLES --- */
        body { font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif; background-color: #f7f7f9; color: #222222; }
        .page-container { max-width: 800px; margin: 50px auto; padding: 0 20px; }
        
        /* --- PROFILE CARD --- */
        .profile-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border: 1px solid #ebebeb;
            padding: 40px;
        }

        /* --- HEADER (Avatar & Name) --- */
        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            border-bottom: 1px solid #ebebeb;
            padding-bottom: 30px;
            margin-bottom: 30px;
        }

        .avatar-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }

        .profile-name { font-size: 28px; font-weight: 800; margin: 0 0 5px 0; color: #222; }
        .profile-email { font-size: 16px; color: #717171; margin: 0; }

        /* --- DETAILS GRID --- */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 40px;
        }

        .detail-item {
            background: #fdfdfd;
            padding: 15px 20px;
            border-radius: 12px;
            border: 1px solid #f0f0f0;
        }

        .detail-label { font-size: 13px; font-weight: 700; color: #717171; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px; }
        .detail-value { font-size: 16px; font-weight: 600; color: #222222; }

        /* --- VERIFICATION ID SECTION --- */
        .id-section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 15px;
            color: #222;
        }

        .id-img-container {
            width: 100%;
            max-width: 400px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #ddd;
        }

        .id-img {
            width: 100%;
            height: auto;
            display: block;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 700;
        }
        .status-active { background: #e8f5e9; color: #2e7d32; }
        .status-pending { background: #fff3e0; color: #ef6c00; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        
        <div class="profile-card">
            
            <%-- PROFILE HEADER --%>
            <div class="profile-header">
                <img id="imgAvatar" runat="server" class="avatar-img" src="https://via.placeholder.com/150" alt="Host Avatar" />
                <h2 class="profile-name"><asp:Label ID="lblFullName" runat="server"></asp:Label></h2>
                <p class="profile-email"><asp:Label ID="lblTopEmail" runat="server"></asp:Label></p>
            </div>

            <%-- PERSONAL DETAILS GRID --%>
            <div class="details-grid">
                <div class="detail-item">
                    <div class="detail-label">First Name</div>
                    <div class="detail-value"><asp:Label ID="lblFname" runat="server"></asp:Label></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Last Name</div>
                    <div class="detail-value"><asp:Label ID="lblLname" runat="server"></asp:Label></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Phone Number</div>
                    <div class="detail-value"><asp:Label ID="lblPhone" runat="server"></asp:Label></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Account Status</div>
                    <div class="detail-value"><asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label></div>
                </div>
                
                <%-- Total Properties Listed --%>
                <div class="detail-item">
                    <div class="detail-label">Total Properties Listed</div>
                    <div class="detail-value" style="color: #E61E4D; font-size: 18px;">
                        <asp:Label ID="lblTotalProperties" runat="server">0</asp:Label>
                    </div>
                </div>
            </div>

            <%-- VERIFICATION ID IMAGE --%>
            <div class="id-section">
                <h3 class="id-section-title">Verification ID Proof</h3>
                <div class="id-img-container">
                    <img id="imgHostId" runat="server" class="id-img" alt="Verification ID" />
                </div>
            </div>

        </div>

    </div>
</asp:Content>