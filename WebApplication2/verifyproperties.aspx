<%@ Page Title="Verify Properties" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="verifyproperties.aspx.cs" Inherits="WebApplication2.verifyproperties" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Container and Header */
        .page-container { padding: 30px; background-color: #f4f7f6; min-height: 100vh; }
        .page-header { margin-bottom: 30px; }

        /* Grid Layout */
        .property-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        /* Property Card Design */
        .property-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
            cursor: pointer;
            height: 100%;
        }

        .property-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.1);
        }

        .img-container {
            width: 100%;
            height: 200px;
            overflow: hidden;
            background-color: #eee;
        }

        .img-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .card-details { padding: 20px; }
        .card-title { font-weight: 700; font-size: 1.1rem; color: #222; margin-bottom: 5px; }
        .card-location { color: #717171; font-size: 0.9rem; margin-bottom: 15px; }
        .card-price { font-weight: 800; color: #E61E4D; font-size: 1.1rem; }

        .pending-badge {
            background-color: #fff8e1;
            color: #f59e0b;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <div class="page-header">
            <h2 class="fw-bold">Property Approval Inbox</h2>
            <p class="text-muted">Select a property to review details and approve/reject.</p>
        </div>

        <asp:DataList ID="dlPendingProperties" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="property-grid" OnSelectedIndexChanged="dlPendingProperties_SelectedIndexChanged">
            <ItemTemplate>
                <asp:LinkButton ID="lnkViewDetails" runat="server" OnClick="lnkViewDetails_Click" CommandArgument='<%# Eval("pid") %>' style="text-decoration:none; color:inherit;">
                    <div class="property-card">
                        <div class="img-container">
                            <%-- Image logic: If null, show placeholder --%>
                            <img src='<%# Eval("pimage") != DBNull.Value ? ResolveUrl("~/" + Eval("pimage")) : "https://via.placeholder.com/150" %>' />
                        </div>
                        <div class="card-details">
                            <span class="pending-badge"><i class="bi bi-clock-history"></i> Waiting for Review</span>
                            <div class="card-title"><%# Eval("title") %></div>
                            <div class="card-location"><i class="bi bi-geo-alt"></i> <%# Eval("district") %></div>
                            <div class="card-price">₹<%# Eval("price") %> <span style="color:#717171; font-weight:400; font-size:0.8rem;">/ night</span></div>
                        </div>
                    </div>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:DataList>

        <%-- Message if no properties are pending --%>
        <asp:Label ID="lblNoData" runat="server" Text="Great job! No properties are waiting for approval." Visible="false" CssClass="alert alert-info d-block mt-4"></asp:Label>
    </div>
</asp:Content>