<%@ Page Title="Admin Revenue Tracker" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminpayment.aspx.cs" Inherits="WebApplication2.adminpayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; font-family: 'Inter', sans-serif; }
        .page-title { font-size: 28px; font-weight: 800; margin-bottom: 25px; color: #222; }

        /* --- REVENUE DASHBOARD CARD --- */
        .revenue-card {
            background: #111;
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-left: 8px solid #E61E4D;
        }
        .rev-label { font-size: 14px; text-transform: uppercase; letter-spacing: 1px; color: #888; font-weight: 600; }
        .rev-amount { font-size: 42px; font-weight: 800; color: #fff; margin-top: 5px; }
        .rev-icon { font-size: 50px; color: #E61E4D; opacity: 0.9; }

        /* --- TRANSACTION TABLE --- */
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; border: 1px solid #eee; }
        .table { width: 100%; border-collapse: collapse; }
        .table th { background: #f8f9fa; padding: 18px 20px; text-align: left; font-size: 12px; color: #666; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid #eee; }
        .table td { padding: 18px 20px; font-size: 14px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        .host-name { font-weight: 700; color: #222; margin-bottom: 2px; }
        .prop-badge { background: #f0f0f0; color: #555; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; border: 1px solid #ddd; }
        
        .amount-host { color: #2e7d32; font-weight: 700; } /* Green for Host Share */
        .amount-admin { color: #E61E4D; font-weight: 700; } /* Red for Admin Commission */

        .status-badge { 
            background: #e8f5e9; 
            color: #2e7d32; 
            padding: 4px 10px; 
            border-radius: 6px; 
            font-size: 11px; 
            font-weight: 700; 
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <h1 class="page-title">Platform Revenue Tracker</h1>

        <%-- TOP CARD: TOTAL ADMIN EARNINGS (10%) --%>
        <div class="revenue-card">
            <div>
                <div class="rev-label">Total Platform Commission (10%)</div>
                <div class="rev-amount">₹<asp:Label ID="lblAdminTotal" runat="server" Text="0.00"></asp:Label></div>
            </div>
            <div class="rev-icon">
                <i class="fas fa-hand-holding-usd"></i>
            </div>
        </div>

        <h3 class="fw-bold mb-3" style="font-size: 18px; color: #444;">Host Performance & Earnings Summary</h3>
        
        <div class="table-container">
            <asp:Repeater ID="rptPayments" runat="server">
                <HeaderTemplate>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Host ID</th>
                                <th>Host Name</th>
                                <th>Properties Listed</th>
                                <th>Host Earnings (90%)</th>
                                <th>Platform Fee (10%)</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><strong>#<%# Eval("hid") %></strong></td>
                        <td class="host-name"><%# Eval("hostfullname") %></td>
                        <td>
                            <span class="prop-badge">
                                <%# Eval("property_count") %> Properties
                            </span>
                        </td>
                        <td class="amount-host">₹<%# Convert.ToDouble(Eval("host_total_earnings")).ToString("N2") %></td>
                        <td class="amount-admin">₹<%# Convert.ToDouble(Eval("admin_total_commission")).ToString("N2") %></td>
                        <td><span class="status-badge">Verified Host</span></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            
            <%-- Message shown when there are no records --%>
            <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="text-center py-5">
                <i class="fas fa-users-slash fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">No host activity found in the records.</h4>
            </asp:Panel>
        </div>
    </div>
</asp:Content>