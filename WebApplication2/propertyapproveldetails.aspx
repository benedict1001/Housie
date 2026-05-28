<%@ Page Title="Property Approval Details" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="propertyapproveldetails.aspx.cs" Inherits="WebApplication2.propertyapproveldetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .details-container { 
            background: white; 
            padding: 40px; 
            border-radius: 20px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
            margin-top: 20px;
        }
        .main-img { 
            width: 100%; 
            max-height: 400px; 
            object-fit: cover; 
            border-radius: 15px; 
            margin-bottom: 20px; 
        }
        .info-badge { 
            background: #f8f9fa; 
            padding: 10px 20px; 
            border-radius: 10px; 
            margin-right: 10px; 
            margin-bottom: 10px;
            display: inline-block; 
            font-weight: 600;
        }
        .action-box { 
            border-top: 1px solid #eee; 
            margin-top: 30px; 
            padding-top: 30px; 
        }
        .property-title {
            font-size: 2rem;
            font-weight: 800;
            color: #333;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-5">
        <div class="details-container">
            <div class="row">
                <div class="col-md-6">
                    <asp:Image ID="imgMain" runat="server" CssClass="main-img" />
                </div>
                
                <div class="col-md-6">
                    <h1 class="property-title">
                        <asp:Label ID="lblTitle" runat="server"></asp:Label>
                    </h1>
                    <h4 class="text-danger mt-3">
                        ₹<asp:Label ID="lblPrice" runat="server"></asp:Label> / night
                    </h4>
                    <hr />
                    <p class="fs-5 text-muted">
                        <asp:Label ID="lblDesc" runat="server"></asp:Label>
                    </p>
                    
                    <div class="mt-4">
                        <div class="info-badge">Rooms: <asp:Label ID="lblRooms" runat="server"></asp:Label></div>
                        <div class="info-badge">Guests: <asp:Label ID="lblGuests" runat="server"></asp:Label></div>
                        <div class="info-badge">Bathroom: <asp:Label ID="lblbathroom" runat="server"></asp:Label></div>
                        <div class="info-badge">Bed: <asp:Label ID="lblbed" runat="server"></asp:Label></div>
                    </div>

                    <div class="mt-2">
                        <div class="info-badge border">
                            Host ID: <asp:Label ID="lblHostID" runat="server" CssClass="text-dark"></asp:Label>
                        </div>
                        <div class="info-badge border">
                            Host Name: <asp:Label ID="lblHostName" runat="server" CssClass="text-primary"></asp:Label>
                        </div>
                        <div class="info-badge border">
                            Phone: <asp:Label ID="lblHostPhone" runat="server" CssClass="text-dark"></asp:Label>
                        </div>
                        <div class="info-badge border">
                            Email: <asp:Label ID="lblHostEmail" runat="server" CssClass="text-dark"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="action-box">
                <h4 class="fw-bold"><i class="bi bi-shield-check"></i> Admin Action</h4>
                <div class="row mt-3">
                    <div class="col-md-8">
                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" 
                            placeholder="If rejecting, please state the reason here..." 
                            TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <div class="col-md-4 d-flex align-items-center justify-content-end">
                        <asp:Button ID="btnApprove" runat="server" Text="Approve Property" 
                            CssClass="btn btn-success btn-lg me-2 px-4" OnClick="btnApprove_Click" />
                        
                        <asp:Button ID="btnReject" runat="server" Text="Reject" 
                            CssClass="btn btn-outline-danger btn-lg px-4" OnClick="btnReject_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>