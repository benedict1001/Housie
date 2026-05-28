<%@ Page Title="View Properties" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="viewproperty.aspx.cs" Inherits="WebApplication2.viewproperty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- 1. Global Background --- */
        body {
            /* Soft Blue-Grey Gradient for a professional Admin look */
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%) !important;
            background-attachment: fixed !important;
            min-height: 100vh;
        }

        /* --- Page Styling --- */
        .page-header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05); /* Softer, deeper shadow */
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 5px solid #E61E4D; /* Brand Color Accent */
        }

        .page-title {
            font-weight: 800;
            color: #1e293b;
            margin: 0;
            font-size: 1.8rem;
        }

        /* --- GridView Styling --- */
        .table-responsive {
            background: rgba(255, 255, 255, 0.6); /* Slight glass effect behind table */
            border-radius: 15px;
            padding: 10px;
        }

        .custom-grid {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px; /* Space between rows */
            border: none;
        }

        /* Dark Header for Contrast */
        .custom-grid th {
            background-color: #1e293b; /* Dark Slate */
            color: #ffffff;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding: 18px;
            border: none;
            letter-spacing: 0.5px;
        }

        /* Rounded corners for the header row */
        .custom-grid th:first-child { border-top-left-radius: 10px; border-bottom-left-radius: 10px; }
        .custom-grid th:last-child { border-top-right-radius: 10px; border-bottom-right-radius: 10px; }

        .custom-grid tr {
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            transition: all 0.2s ease-in-out;
        }

        /* Rounded corners for data rows */
        .custom-grid tr td:first-child { border-top-left-radius: 10px; border-bottom-left-radius: 10px; }
        .custom-grid tr td:last-child { border-top-right-radius: 10px; border-bottom-right-radius: 10px; }

        .custom-grid tr:hover {
            transform: translateY(-3px) scale(1.005);
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
            z-index: 2;
            position: relative;
        }

        .custom-grid td {
            padding: 15px;
            vertical-align: middle;
            border: none;
            color: #475569; /* Softer dark grey for text */
            font-weight: 500;
        }

        /* --- Image Styling --- */
        .prop-thumb {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: 2px solid white;
        }

        /* --- Status Badge --- */
        .status-badge {
            padding: 6px 15px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-active { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .status-pending { background: #fef9c3; color: #a16207; border: 1px solid #fde047; }
        
        /* Button Styling */
        .btn-view {
            background-color: #f1f5f9;
            color: #0f172a;
            border-radius: 50px;
            padding: 5px 15px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
        }
        .btn-view:hover {
            background-color: #E61E4D;
            color: white;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <div>
            <h2 class="page-title">All Properties</h2>
            <p class="text-muted mb-0">View and manage all listed properties.</p>
        </div>
        <div>
            <span class="badge rounded-pill px-4 py-2" style="background-color: #1e293b; font-size: 0.9rem;">
                Total: <asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label>
            </span>
        </div>
    </div>

    <div class="card p-4 mb-4" style="border:none; border-radius:15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
        <h5 class="mb-3" style="font-weight:700; color:#1e293b;">Filter Properties</h5>
        <div class="row g-3">
            
            <div class="col-md-4">
                <label class="form-label text-muted small fw-bold">Location</label>
                <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control rounded-pill" AppendDataBoundItems="true">
                    <asp:ListItem Value="0" Text="All Locations"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-4">
                <label class="form-label text-muted small fw-bold">Property Type</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control rounded-pill" AppendDataBoundItems="true">
                    <asp:ListItem Value="0" Text="All Types"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-4 d-flex align-items-end">
           <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" OnClick="btnFilter_Click" CssClass="btn btn-primary rounded-pill px-4 me-2" style="background-color: #E61E4D; border:none;" /> 
                <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn btn-light rounded-pill px-4" />
            </div> 

        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="gvProperties" runat="server" AutoGenerateColumns="False" 
            CssClass="custom-grid" GridLines="None" 
            EmptyDataText="No properties found matching your filters.">
            
            <Columns>
                
                <asp:TemplateField HeaderText="Image">
                    <ItemTemplate>
                        <img src='<%# "data:image/jpg;base64," + Convert.ToBase64String((byte[])Eval("pimage")) %>' class="prop-thumb" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="title" HeaderText="Property Name" HeaderStyle-CssClass="ps-4" ItemStyle-CssClass="ps-4" />
                <asp:BoundField DataField="location" HeaderText="Location" />
                
                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        <strong style="color: #E61E4D;">₹<%# Eval("price") %></strong>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="host_id" HeaderText="Host ID" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="status-badge status-active"><%# Eval("status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href="#" class="btn-view"><i class="bi bi-eye"></i> View</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

</asp:Content>