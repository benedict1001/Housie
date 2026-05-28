<%@ Page Title="" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminreport.aspx.cs" Inherits="WebApplication2.adminreport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .report-header {
            background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 30px 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .filter-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .form-label { font-weight: 700; color: #475569; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control, .form-select { border-radius: 10px; border: 1px solid #cbd5e1; padding: 12px; }
        .form-control:focus, .form-select:focus { border-color: #2563eb; box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1); }
        
        .btn-generate {
            background: #2563eb;
            color: white;
            font-weight: 700;
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            transition: 0.3s;
            height: 100%;
            width: 100%;
        }
        .btn-generate:hover { background: #1d4ed8; transform: translateY(-2px); box-shadow: 0 8px 15px rgba(37, 99, 235, 0.2); color: white; }

        .summary-card {
            background: #f8fafc;
            border-left: 5px solid #10b981;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .summary-title { font-size: 0.9rem; color: #64748b; font-weight: 700; text-transform: uppercase; }
        .summary-value { font-size: 2rem; font-weight: 800; color: #0f172a; margin: 0; }

        /* Modern GridView Styling */
        .modern-grid { width: 100%; border-collapse: separate; border-spacing: 0; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .modern-grid th { background: #f1f5f9; color: #334155; font-weight: 700; padding: 16px; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e2e8f0; text-align: left; }
        .modern-grid td { padding: 16px; border-bottom: 1px solid #f1f5f9; color: #475569; font-size: 0.95rem; vertical-align: middle; }
        .modern-grid tr:hover td { background-color: #f8fafc; }
        .modern-grid tr:last-child td { border-bottom: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="report-header">
        <h1 class="fw-bold display-6 mb-1">Business Reports</h1>
        <p class="mb-0 opacity-75">Generate, view, and analyze your platform's performance.</p>
    </div>

    <div class="filter-card">
        <div class="row g-3 align-items-end">
            <div class="col-lg-2">
                <label class="form-label">Report Type</label>
                <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-select">
                    <asp:ListItem Value="Bookings">Revenue & Bookings</asp:ListItem>
                    <asp:ListItem Value="Properties">New Property Listings</asp:ListItem>
                    <asp:ListItem Value="Customers">Registered Customers</asp:ListItem>
                    <asp:ListItem Value="Cancellations">Cancellations</asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <div class="col-lg-3">
                <label class="form-label">Filter By Host (Bookings)</label>
                <asp:DropDownList ID="ddlHost" runat="server" CssClass="form-select">
                </asp:DropDownList>
            </div>

            <div class="col-lg-2">
                <label class="form-label">Start Date</label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
            <div class="col-lg-2">
                <label class="form-label">End Date</label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
            <div class="col-lg-3">
                <asp:Button ID="btnGenerate" runat="server" Text="Generate Report" CssClass="btn-generate" OnClick="btnGenerate_Click" />
            </div>
        </div>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" CssClass="mt-2 d-block fw-bold"></asp:Label>
    </div>

    <div id="summarySection" runat="server" visible="false" class="summary-card">
        <div>
            <div class="summary-title">Total Records Found</div>
            <p class="summary-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></p>
        </div>
        
        <div class="d-flex gap-5 text-end" id="revenueBlock" runat="server" visible="false">
            <div>
                <div class="summary-title" style="color: #3b82f6;">Host Earnings</div>
                <p class="summary-value" style="color: #3b82f6;">₹<asp:Label ID="lblHostRevenue" runat="server" Text="0"></asp:Label></p>
            </div>
            <div>
                <div class="summary-title" style="color: #f59e0b;">Admin Earnings</div>
                <p class="summary-value" style="color: #f59e0b;">₹<asp:Label ID="lblAdminRevenue" runat="server" Text="0"></asp:Label></p>
            </div>
            <div>
                <div class="summary-title" style="color: #10b981;">Total Revenue</div>
                <p class="summary-value" style="color: #10b981;">₹<asp:Label ID="lblTotalRevenue" runat="server" Text="0"></asp:Label></p>
            </div>
        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="gvReport" runat="server" CssClass="modern-grid" AutoGenerateColumns="true" EmptyDataText="No data found for the selected criteria." GridLines="None">
        </asp:GridView>
    </div>
</asp:Content>