<%@ Page Title="Manage Hosts" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminm.aspx.cs" Inherits="WebApplication2.adminm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        .page-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; font-family: 'Inter', sans-serif; }
        .page-title { font-size: 28px; font-weight: 800; margin-bottom: 5px; color: #222; font-family: 'Plus Jakarta Sans', sans-serif; }
        .page-subtitle { color: #717171; margin-bottom: 30px; font-size: 15px; }

        /* Table Styles */
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; border: 1px solid #eee; margin-bottom: 40px; }
        .table { width: 100%; border-collapse: collapse; margin-bottom: 0; }
        .table th { background: #f8f9fa; padding: 18px 20px; text-align: left; font-size: 12px; color: #666; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid #eee; }
        .table td { padding: 18px 20px; font-size: 14px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        /* Profile Layout */
        .host-profile { display: flex; align-items: center; gap: 15px; }
        .host-avatar { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; border: 2px solid #f1f5f9; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .host-name { font-weight: 700; color: #222; margin-bottom: 2px; font-size: 15px; display: block;}
        .host-id { color: #888; font-size: 12px; font-weight: 600; }

        /* Contact Details */
        .contact-text { color: #555; font-size: 13px; display: flex; align-items: center; gap: 8px; margin-bottom: 4px;}
        .contact-text i { color: #a0aec0; width: 14px; }

        /* Badges */
        .status-badge { padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; }
        .badge-pending { background: #fff8e1; color: #f59e0b; border: 1px solid #fde68a; }
        .badge-active { background: #e8f5e9; color: #059669; border: 1px solid #a7f3d0; }
        .badge-suspended { background: #fee2e2; color: #dc2626; border: 1px solid #fecaca; }

        /* Buttons */
        .action-group { display: flex; gap: 8px; }
        .btn-action { padding: 8px 16px; border-radius: 8px; font-weight: 600; font-size: 13px; border: none; cursor: pointer; transition: 0.2s; text-decoration: none; display: inline-block; }
        
        .btn-activate { background: #10b981; color: white; }
        .btn-activate:hover { background: #059669; box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2); }
        
        .btn-suspend { background: #f8f9fa; color: #dc2626; border: 1px solid #fecaca; }
        .btn-suspend:hover { background: #fee2e2; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="page-container">
        <h1 class="page-title"><i class="fas fa-users-cog me-2" style="color: #E61E4D;"></i> Manage Hosts</h1>
        <p class="page-subtitle">View and manage all registered hosts on the Housie platform.</p>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                
                <div class="table-container">
                    <asp:Repeater ID="rptHosts" runat="server" OnItemCommand="rptHosts_ItemCommand">
                        <HeaderTemplate>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Host Profile</th>
                                        <th>Contact Information</th>
                                        <th>Account Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="host-profile">
                                        <img src='<%# GetImageSource(Eval("himage"), Eval("fname").ToString(), Eval("lname").ToString()) %>' class="host-avatar" alt="Avatar" />
                                        <div>
                                            <span class="host-name"><%# Eval("fname") %> <%# Eval("lname") %></span>
                                            <span class="host-id">Host ID: #<%# Eval("hid") %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="contact-text"><i class="fas fa-envelope"></i> <%# Eval("email") %></div>
                                    <div class="contact-text"><i class="fas fa-phone-alt"></i> <%# Eval("phno") %></div>
                                </td>
                                <td>
                                    <span class='status-badge <%# GetStatusCssClass(Eval("status")) %>'>
                                        <%# GetStatusText(Eval("status")) %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-group">
                                        <%-- Show Activate button if Pending (1) or Suspended (3) --%>
                                        <asp:LinkButton ID="btnActivate" runat="server" CssClass="btn-action btn-activate" 
                                            CommandName="Activate" CommandArgument='<%# Eval("hid") %>'
                                            Visible='<%# Eval("status").ToString() != "2" %>'>
                                            <i class="fas fa-check me-1"></i> Activate
                                        </asp:LinkButton>

                                        <%-- Show Suspend button if Active (2) --%>
                                        <asp:LinkButton ID="btnSuspend" runat="server" CssClass="btn-action btn-suspend" 
                                            CommandName="Suspend" CommandArgument='<%# Eval("hid") %>'
                                            Visible='<%# Eval("status").ToString() == "2" %>'
                                            OnClientClick="return confirm('Are you sure you want to suspend this host?');">
                                            <i class="fas fa-ban me-1"></i> Suspend
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoHosts" runat="server" Visible="false" CssClass="text-center py-5">
                        <i class="fas fa-user-slash fa-3x text-muted mb-3 opacity-50"></i>
                        <h4 class="text-muted">No hosts found.</h4>
                        <p class="text-muted small">There are currently no registered hosts in the database.</p>
                    </asp:Panel>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
