<%@ Page Title="Admin - Property Details" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="adminpropertydetails.aspx.cs" Inherits="WebApplication2.adminpropertydetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- Layout & Typography --- */
        .details-container { max-width: 1200px; margin: 40px auto; padding: 0 40px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #222; }
        .prop-title { font-size: 32px; font-weight: 600; margin-bottom: 5px; }
        .prop-address { font-size: 16px; color: #717171; text-decoration: underline; margin-bottom: 24px; }
        
        /* --- 5-IMAGE MOSAIC GALLERY (Imported from Customer Page) --- */
        .gallery-container {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            grid-template-rows: 250px 250px;
            gap: 8px;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
        }

        .gal-img { width: 100%; height: 100%; object-fit: cover; cursor: pointer; transition: filter 0.2s; }
        .gal-img:hover { filter: brightness(0.85); }

        .gal-main { grid-column: 1 / 2; grid-row: 1 / 3; }
        .gal-2 { grid-column: 2 / 3; grid-row: 1 / 2; }
        .gal-3 { grid-column: 3 / 4; grid-row: 1 / 2; }
        .gal-4 { grid-column: 2 / 3; grid-row: 2 / 3; }
        .gal-5 { grid-column: 3 / 4; grid-row: 2 / 3; }

        .show-all-btn {
            position: absolute;
            bottom: 24px;
            right: 24px;
            background: white;
            border: 1px solid #222;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: 0.2s;
        }
        .show-all-btn:hover { background: #f7f7f7; }

        /* --- FULL SCREEN PHOTO MODAL --- */
        .photo-modal {
            display: none; 
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: white; z-index: 9999; overflow-y: auto;
        }
        .photo-modal.show { display: block; }
        
        .photo-modal-header {
            position: sticky; top: 0; padding: 20px 40px; 
            background: white; z-index: 10000;
            display: flex; justify-content: space-between; align-items: center;
        }
        .close-photo-btn {
            background: none; border: none; font-size: 20px; 
            cursor: pointer; display: flex; align-items: center; gap: 8px; font-weight: 600;
            padding: 8px 12px; border-radius: 8px; transition: background 0.2s;
        }
        .close-photo-btn:hover { background: #f0f0f0; }
        
        .photo-modal-content {
            max-width: 800px; margin: 0 auto; padding: 20px 20px 80px 20px;
            display: flex; flex-direction: column; gap: 24px;
        }
        .large-gallery-img {
            width: 100%; height: auto; border-radius: 12px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        /* --- Main Content Split --- */
        .content-split { display: flex; gap: 80px; justify-content: space-between; }
        .left-details { flex: 1; }
        .right-admin-panel { width: 380px; position: sticky; top: 100px; height: fit-content; }

        /* --- Left Side Info --- */
        .prop-stats { font-size: 16px; color: #222; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd; }
        .prop-description { font-size: 16px; line-height: 1.6; color: #444; white-space: pre-wrap; padding-bottom: 30px; border-bottom: 1px solid #ddd; }
        
        /* --- Host & Reviews Styling --- */
        .section-title { font-size: 22px; font-weight: 600; margin: 30px 0 15px 0; color: #222; }
        
        .host-card { display: flex; flex-direction: column; gap: 5px; padding: 20px; border: 1px solid #ddd; border-radius: 12px; background-color: #f9f9f9; margin-bottom: 30px; }
        .host-name { font-size: 18px; font-weight: 600; }
        .host-contact { font-size: 15px; color: #717171; }

        .review-card { padding: 20px 0; border-bottom: 1px solid #ddd; }
        .review-card:last-child { border-bottom: none; }
        .review-header { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .review-rating { font-weight: 600; color: #222; }
        .review-date { color: #717171; font-size: 14px; }
        .review-text { color: #444; line-height: 1.5; font-size: 15px; }

        /* --- Admin Action Box --- */
        .admin-box { background: #fff; border: 1px solid #ddd; border-radius: 12px; padding: 24px; box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
        .admin-box-header { font-size: 22px; font-weight: 600; margin-bottom: 20px; color: #222; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #222; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #b0b0b0; border-radius: 8px; font-size: 14px; resize: vertical; min-height: 100px; font-family: inherit; }
        .form-control:focus { outline: none; border-color: #222; border-width: 2px; padding: 11px; }

        /* --- Buttons --- */
        .btn { width: 100%; padding: 14px; border-radius: 8px; font-size: 16px; font-weight: 600; text-align: center; cursor: pointer; border: none; transition: 0.2s; }
        .btn-flag { background-color: #E61E4D; color: white; }
        .btn-flag:hover { background-color: #D70438; }
        
        .btn-unflag { background-color: #00A699; color: white; }
        .btn-unflag:hover { background-color: #00887A; }

        /* Status Badge */
        .status-badge { display: inline-block; padding: 6px 12px; border-radius: 6px; font-size: 14px; font-weight: 600; margin-bottom: 15px; }
        .badge-active { background-color: #e6f6f5; color: #00887A; }
        .badge-flagged { background-color: #fce8ec; color: #E61E4D; }
        
        @media (max-width: 900px) {
            .gallery-container { grid-template-rows: 150px 150px; }
            .photo-modal-header { padding: 16px 20px; }
            .content-split { flex-direction: column; gap: 40px; }
            .right-admin-panel { width: 100%; position: relative; top: 0; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="details-container">
        <h1 class="prop-title"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
        <div class="prop-address"><asp:Literal ID="litAddress" runat="server"></asp:Literal>, <asp:Literal ID="litDistrict" runat="server"></asp:Literal></div>

        <div class="gallery-container">
            <asp:Image ID="imgProperty" runat="server" CssClass="gal-img gal-main" onclick="openPhotoModal()" />
            
            <asp:Image ID="img2" runat="server" CssClass="gal-img gal-2" ImageUrl="https://via.placeholder.com/400x300?text=Property+Image+2" onclick="openPhotoModal()" />
            <asp:Image ID="img3" runat="server" CssClass="gal-img gal-3" ImageUrl="https://via.placeholder.com/400x300?text=Property+Image+3" onclick="openPhotoModal()" />
            <asp:Image ID="img4" runat="server" CssClass="gal-img gal-4" ImageUrl="https://via.placeholder.com/400x300?text=Property+Image+4" onclick="openPhotoModal()" />
            <asp:Image ID="img5" runat="server" CssClass="gal-img gal-5" ImageUrl="https://via.placeholder.com/400x300?text=Property+Image+5" onclick="openPhotoModal()" />
            
            <button type="button" class="show-all-btn" onclick="openPhotoModal()">
                <svg viewBox="0 0 16 16" style="display:block;height:14px;width:14px;fill:currentColor;float:left;margin-right:8px;" aria-hidden="true" role="presentation" focusable="false"><path d="m3 1.5c.82842712 0 1.5.67157288 1.5 1.5v10c0 .8284271-.67157288 1.5-1.5 1.5h-1.5c-.82842712 0-1.5-.6715729-1.5-1.5v-10c0-.82842712.67157288-1.5 1.5-1.5zm6 0c.8284271 0 1.5.67157288 1.5 1.5v10c0 .8284271-.6715729 1.5-1.5 1.5h-1.5c-.8284271 0-1.5-.6715729-1.5-1.5v-10c0-.82842712.6715729-1.5 1.5-1.5zm6 0c.8284271 0 1.5.67157288 1.5 1.5v10c0 .8284271-.6715729 1.5-1.5 1.5h-1.5c-.8284271 0-1.5-.6715729-1.5-1.5v-10c0-.82842712.6715729-1.5 1.5-1.5z"></path></svg>
                Show all photos
            </button>
        </div>

        <div class="content-split">
            <div class="left-details">
                <div class="prop-stats">
                    <asp:Literal ID="litGuests" runat="server"></asp:Literal> guests · 
                    <asp:Literal ID="litBedrooms" runat="server"></asp:Literal> bedrooms · 
                    <asp:Literal ID="litBeds" runat="server"></asp:Literal> beds · 
                    <asp:Literal ID="litBaths" runat="server"></asp:Literal> baths
                </div>
                
                <h3>About this space</h3>
                <div class="prop-description">
                    <asp:Literal ID="litDescription" runat="server"></asp:Literal>
                </div>

                <h3 class="section-title">Host Details</h3>
                <div class="host-card">
                    <div class="host-name">Name: <asp:Literal ID="litHostName" runat="server"></asp:Literal></div>
                    <div class="host-contact">Email: <asp:Literal ID="litHostEmail" runat="server"></asp:Literal></div>
                    <div class="host-contact">Phone: <asp:Literal ID="litHostPhone" runat="server"></asp:Literal></div>
                </div>

                <h3 class="section-title">Guest Reviews</h3>
                <asp:Repeater ID="rptReviews" runat="server">
                    <ItemTemplate>
                        <div class="review-card">
                            <div class="review-header">
                                <div class="review-rating">★ <%# Eval("rating") %> Rating</div>
                                <div class="review-date"><%# Convert.ToDateTime(Eval("reviewdate")).ToString("dd MMM yyyy") %></div>
                            </div>
                            <div class="review-text"><%# Eval("reviewtext") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoReviews" runat="server" Visible="false" Text="This property has no reviews yet." ForeColor="#717171"></asp:Label>
            </div>

            <div class="right-admin-panel">
                <div class="admin-box">
                    <div class="admin-box-header">Admin Controls</div>
                    
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="status-badge badge-active"></asp:Label>
                    
                    <div style="font-size: 20px; font-weight: 600; margin-bottom: 20px;">
                        ₹<asp:Literal ID="litPrice" runat="server"></asp:Literal> <span style="font-size: 16px; font-weight: 400; color: #717171;">night</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Admin Message / Flag Reason</label>
                        <asp:TextBox ID="txtAdminMessage" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Enter reason for flagging or any admin notes here..."></asp:TextBox>
                    </div>

                    <asp:HiddenField ID="hfCurrentStatus" runat="server" />
                    
                    <asp:Button ID="btnToggleFlag" runat="server" Text="Flag Property" CssClass="btn btn-flag" OnClick="btnToggleFlag_Click" />
                </div>
            </div>
        </div>
    </div>

    <div id="fullPhotoModal" class="photo-modal">
        <div class="photo-modal-header">
            <button type="button" class="close-photo-btn" onclick="closePhotoModal()">
                <svg viewBox="0 0 32 32" style="display:block;height:16px;width:16px;fill:none;stroke:currentcolor;stroke-width:4;overflow:visible"><path d="m20 28-11.29289322-11.2928932c-.39052429-.3905243-.39052429-1.0236893 0-1.4142136l11.29289322-11.2928932"></path></svg>
            </button>
            <div style="font-size: 16px; font-weight: 600;">Photo Gallery</div>
            <div style="width: 24px;"></div> 
        </div>
        <div class="photo-modal-content" id="modalImageInjectArea">
            </div>
    </div>

    <script>
        // --- PHOTO MODAL LOGIC ---
        function openPhotoModal() {
            var injectArea = document.getElementById('modalImageInjectArea');
            injectArea.innerHTML = ''; 
            
            var galleryImages = document.querySelectorAll('.gallery-container .gal-img');
            
            galleryImages.forEach(function(img) {
                // Ensure we don't load empty images if they don't have a source
                if(img.src && !img.src.includes('placeholder.com')) {
                    var newImg = document.createElement('img');
                    newImg.src = img.src;
                    newImg.className = 'large-gallery-img';
                    injectArea.appendChild(newImg);
                }
            });

            document.getElementById('fullPhotoModal').classList.add('show');
            document.body.style.overflow = 'hidden'; 
        }

        function closePhotoModal() {
            document.getElementById('fullPhotoModal').classList.remove('show');
            document.body.style.overflow = 'auto'; 
        }
    </script>
</asp:Content>