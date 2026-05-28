<%@ Page Title="Host Details" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="activehostdetails.aspx.cs" Inherits="WebApplication2.activehostdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .details-container {
            width: 700px;
            margin: 30px auto;
            background: #fff;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 10px;
            font-family: 'Segoe UI', sans-serif;
        }
        .image-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            gap: 20px;
        }
        .img-card {
            flex: 1;
            text-align: center;
        }
        .img-card h5 {
            margin-bottom: 10px;
            color: #555;
        }
        .display-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border: 2px solid #eee;
            border-radius: 8px;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }
        .info-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        .label-cell {
            font-weight: bold;
            color: #333;
            width: 30%;
        }
        .action-area {
            text-align: center;
            padding-top: 20px;
        }
        .btn {
            padding: 10px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            border: none;
            margin: 0 10px;
        }
        .btn-approve { background-color: #28a745; color: white; }
        .btn-reject { background-color: #dc3545; color: white; }
        .btn:hover { opacity: 0.9; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="details-container">
        <h2 style="text-align:center; color:#333;">Host Verification Profile</h2>
        <hr />

        <div class="image-section">
            <div class="img-card">
                <h5>Profile Photo</h5>
                <asp:Image ID="imgProfile" runat="server" CssClass="display-img" AlternateText="No Profile Photo" />
            </div>
            <div class="img-card">
                <h5>ID Proof Document</h5>
                <asp:Image ID="imgID" runat="server" CssClass="display-img" AlternateText="No ID Document" />
            </div>
        </div>

        <table class="info-table">
            <tr>
                <td class="label-cell">First Name</td>
                <td><asp:Label ID="lblFname" runat="server" Text="N/A"></asp:Label></td>
            </tr>
            <tr>
                <td class="label-cell">Last Name</td>
                <td><asp:Label ID="lblLname" runat="server" Text="N/A"></asp:Label></td>
            </tr>
            <tr>
                <td class="label-cell">Email Address</td>
                <td><asp:Label ID="lblEmail" runat="server" Text="N/A"></asp:Label></td>
            </tr>
            <tr>
                <td class="label-cell">Phone Number</td>
                <td><asp:Label ID="lblPhone" runat="server" Text="N/A"></asp:Label></td>
            </tr>
        </table>

        <div class="action-area">
         
            <asp:Button ID="btnReject" runat="server" Text="Remove / Block" CssClass="btn btn-reject" OnClick="btnReject_Click" OnClientClick="return confirm('Are you sure you want to reject this host?');" />
        </div>
    </div>
</asp:Content>