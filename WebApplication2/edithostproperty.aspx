<%@ Page Title="Edit Property" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="edithostproperty.aspx.cs" Inherits="WebApplication2.edithostproperty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body { background-image: url('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=1920&auto=format&fit=crop') !important; background-size: cover !important; background-attachment: fixed !important; }
        .main-card { border: 1px solid rgba(255, 255, 255, 0.8); border-radius: 30px; box-shadow: 0 30px 60px rgba(0, 0, 0, 0.25); background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(186, 230, 253, 0.9) 30%, rgba(233, 213, 255, 0.9) 60%, rgba(255, 237, 213, 0.9) 100%); backdrop-filter: blur(15px); padding: 3rem; margin: 40px auto; max-width: 950px; }
        
        /* Fixed CSS Warnings */
        .section-title { 
            font-weight: 800; font-size: 1.1rem; margin-bottom: 25px; 
            background: linear-gradient(to right, #E61E4D, #7c3aed, #ea580c); 
            background-clip: text; 
            -webkit-background-clip: text; 
            color: transparent; 
            text-transform: uppercase; letter-spacing: 1px; display: flex; align-items: center; 
        }
        
        .form-label { font-weight: 700; color: #334155; font-size: 0.8rem; margin-bottom: 8px; display: block; }
        .form-control { border-radius: 14px; border: 2px solid transparent; padding: 12px; background: rgba(255, 255, 255, 0.7); transition: all 0.3s ease; width: 100%; }
        .btn-housie { background: linear-gradient(45deg, #E61E4D, #db2777, #ea580c); background-size: 200% auto; color: white; font-weight: 800; border: none; border-radius: 16px; padding: 18px; box-shadow: 0 10px 20px rgba(230, 30, 77, 0.3); transition: 0.4s; width: 100%; cursor: pointer; }
        .current-img-wrapper { background: white; padding: 8px; border-radius: 18px; display: inline-block; box-shadow: 0 10px 20px rgba(0,0,0,0.1); margin-bottom: 15px; }
        .current-img { width: 160px; height: 100px; object-fit: cover; border-radius: 12px; }
        .gallery-slot { background: rgba(255, 255, 255, 0.5); padding: 15px; border-radius: 15px; border: 1px solid rgba(255,255,255,0.8); text-align: center; margin-bottom: 15px; }
        .gallery-img-preview { width: 100%; height: 120px; object-fit: cover; border-radius: 10px; margin-bottom: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="card main-card">
            <h1 class="mb-4" style="font-weight: 900; color: #1e293b;">Update Your Listing</h1>
            
            <h5 class="section-title"><i class="fas fa-info-circle me-2"></i>Step 1: The Basics</h5>
            <div class="row g-4 mb-5">
                <div class="col-12">
                    <label class="form-label">Property Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Property Type</label>
                    <asp:DropDownList ID="ddlPropertyType" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Pool Available?</label>
                    <asp:DropDownList ID="ddlPool" runat="server" CssClass="form-control">
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Nightly Price (₹)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" min="1"></asp:TextBox>
                </div>
            </div>

            <h5 class="section-title"><i class="fas fa-bed me-2"></i>Step 2: Capacity</h5>
            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <label class="form-label">Bedrooms</label>
                    <asp:TextBox ID="txtBedrooms" runat="server" CssClass="form-control" TextMode="Number" min="1"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Bathrooms</label>
                    <asp:TextBox ID="txtBathrooms" runat="server" CssClass="form-control" TextMode="Number" min="1"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Total Beds</label>
                    <asp:TextBox ID="txtBeds" runat="server" CssClass="form-control" TextMode="Number" min="1"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Max Guests</label>
                    <asp:TextBox ID="txtGuests" runat="server" CssClass="form-control" TextMode="Number" min="1"></asp:TextBox>
                </div>
            </div>

            <h5 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Step 3: Location & Details</h5>
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <label class="form-label">District</label>
                    <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="col-md-8">
                    <label class="form-label">Full Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                </div>
                <div class="col-12">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                </div>
            </div>

            <h5 class="section-title"><i class="fas fa-camera me-2"></i>Step 4: Media Gallery</h5>
            <div class="mb-5 text-center">
                <div class="current-img-wrapper"><asp:Image ID="imgPrev" runat="server" CssClass="current-img" /></div>
                <div class="mt-3 mx-auto" style="max-width: 400px;">
                    <label class="form-label">Change Main Image</label>
                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                </div>
            </div>

            <div class="row g-3 mb-5">
                <div class="col-md-4"><div class="gallery-slot"><asp:Image ID="imgGallery1" runat="server" CssClass="gallery-img-preview" /><asp:FileUpload ID="fuGallery1" runat="server" CssClass="form-control form-control-sm" /></div></div>
                <div class="col-md-4"><div class="gallery-slot"><asp:Image ID="imgGallery2" runat="server" CssClass="gallery-img-preview" /><asp:FileUpload ID="fuGallery2" runat="server" CssClass="form-control form-control-sm" /></div></div>
                <div class="col-md-4"><div class="gallery-slot"><asp:Image ID="imgGallery3" runat="server" CssClass="gallery-img-preview" /><asp:FileUpload ID="fuGallery3" runat="server" CssClass="form-control form-control-sm" /></div></div>
                <div class="col-md-4"><div class="gallery-slot"><asp:Image ID="imgGallery4" runat="server" CssClass="gallery-img-preview" /><asp:FileUpload ID="fuGallery4" runat="server" CssClass="form-control form-control-sm" /></div></div>
                <div class="col-md-4"><div class="gallery-slot"><asp:Image ID="imgGallery5" runat="server" CssClass="gallery-img-preview" /><asp:FileUpload ID="fuGallery5" runat="server" CssClass="form-control form-control-sm" /></div></div>
            </div>

            <asp:Button ID="btnUpdate" runat="server" Text="Update Listing" CssClass="btn btn-housie" OnClick="btnUpdate_Click" />
        </div>
    </div>
</asp:Content>