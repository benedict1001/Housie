<%@ Page Title="Add Property - Housie" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="add_property.aspx.cs" Inherits="WebApplication2.add_property" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .main-card { 
            border: 1px solid rgba(255, 255, 255, 0.8); border-radius: 30px; 
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.25);
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(186,230,253,0.9) 30%, rgba(233,213,255,0.9) 60%, rgba(255,237,213,0.9) 100%);
            backdrop-filter: blur(15px); padding: 3rem; margin-top: 20px; 
        }

        /* Corrected CSS to remove 'text' value warnings in Visual Studio [cite: 2026-03-03] */
        .section-title { 
            font-weight: 800; 
            font-size: 1.1rem; 
            margin-bottom: 25px; 
            background: linear-gradient(to right, #E61E4D, #7c3aed, #ea580c); 
            -webkit-background-clip: text; 
            background-clip: text; 
            -webkit-text-fill-color: transparent; 
            color: transparent; 
            text-transform: uppercase; 
            letter-spacing: 1px; 
        }

        .form-label { font-weight: 700; color: #334155; font-size: 0.8rem; margin-bottom: 8px; display: block; }
        .form-control, .form-select { border-radius: 14px; border: 2px solid transparent; padding: 14px; background: rgba(255, 255, 255, 0.7); transition: 0.3s; }
        .form-control:focus, .form-select:focus { background: #fff; border-color: #E61E4D; box-shadow: 0 0 0 4px rgba(230, 30, 77, 0.1); outline: none; }
        .btn-housie { background: linear-gradient(45deg, #E61E4D, #db2777, #ea580c); background-size: 200% auto; color: white; font-weight: 800; border: none; border-radius: 16px; padding: 18px; box-shadow: 0 10px 20px rgba(230, 30, 77, 0.3); transition: 0.4s; cursor: pointer; }
        .btn-housie:hover { background-position: right center; transform: translateY(-4px); box-shadow: 0 15px 25px rgba(230, 30, 77, 0.4); color: white; }
    </style></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-9 col-lg-10">
                <div class="card main-card">
                    <h1 class="mb-4" style="font-weight: 900; color: #1e293b;">Showcase your space</h1>
                    
                    <h5 class="section-title">Step 1: The Basics</h5>
                    <div class="row g-4 mb-5">
                        <div class="col-12">
                            <label class="form-label">Property Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="A catchy name for your place"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Property Type</label>
                            <asp:DropDownList ID="ddlPropertyType" runat="server" CssClass="form-select form-control"></asp:DropDownList>
                        </div>
                        
                        <%-- Pool status dropdown matching your varchar(5) DB column --%>
                        <div class="col-md-4">
                            <label class="form-label">Pool Available?</label>
                            <asp:DropDownList ID="ddlPool" runat="server" CssClass="form-select form-control">
                                <asp:ListItem Text="No" Value="No"></asp:ListItem>
                                <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Nightly Base Price (₹)</label>
                            <%-- Added min="1" --%>
                            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" min="1" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                        </div>
                    </div>

                    <h5 class="section-title">Step 2: Capacity</h5>
                    <div class="row g-4 mb-5">
                        <%-- Added min="1" to all capacity fields --%>
                        <div class="col-md-3"><label class="form-label">Bedrooms</label><asp:TextBox ID="txtBedrooms" runat="server" TextMode="Number" min="1" CssClass="form-control" Text="1"></asp:TextBox></div>
                        <div class="col-md-3"><label class="form-label">Bathrooms</label><asp:TextBox ID="txtBathrooms" runat="server" TextMode="Number" min="1" CssClass="form-control" Text="1"></asp:TextBox></div>
                        <div class="col-md-3"><label class="form-label">Total Beds</label><asp:TextBox ID="txtBeds" runat="server" TextMode="Number" min="1" CssClass="form-control" Text="1"></asp:TextBox></div>
                        <div class="col-md-3"><label class="form-label">Max Occupancy</label><asp:TextBox ID="txtGuests" runat="server" TextMode="Number" min="1" CssClass="form-control" Text="1"></asp:TextBox></div>
                    </div>

                    <h5 class="section-title">Step 3: Location & Info</h5>
                    <div class="mb-4"><label class="form-label">District</label><asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-select form-control"></asp:DropDownList></div>
                    
                    <%-- NEW LOCATION TYPE DROPDOWN --%>
                    <div class="mb-4"><label class="form-label">Location Type</label><asp:DropDownList ID="ddlLocationType" runat="server" CssClass="form-select form-control"></asp:DropDownList></div>
                    
                    <div class="mb-4"><label class="form-label">Full Address</label><asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Street, City, District"></asp:TextBox></div>
                    <div class="mb-5"><label class="form-label">Describe your place</label><asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="What makes your home unique?"></asp:TextBox></div>

                    <h5 class="section-title">Step 4: Media</h5>
                    <div class="mb-5"><label class="form-label">Upload a Cover Photo</label><asp:FileUpload ID="fileMainImage" runat="server" CssClass="form-control" /></div>

                    <div class="pt-3">
                        <asp:Label ID="lblDebug" runat="server" Font-Bold="true" CssClass="mb-2 d-block"></asp:Label>
                        <asp:Button ID="btnSaveProperty" runat="server" Text="Publish Your Listing" CssClass="btn btn-housie w-100" OnClick="btnSaveProperty_Click" />
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showSuccessPopup() {
                Swal.fire({
                    title: 'Success!',
                    text: 'property details uploaded',
                    icon: 'success',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#E61E4D',
                    allowOutsideClick: false,
                    allowEscapeKey: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'hosthome.aspx';
                    }
                });
            }
        </script>

    </div></asp:Content>