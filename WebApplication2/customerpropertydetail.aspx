<%@ Page Title="Housie - Property Details" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customerpropertydetail.aspx.cs" Inherits="WebApplication2.customerpropertydetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- FULL SCREEN BACKGROUND --- */
        .glass-wrapper {
            min-height: 100vh;
            width: 100%;
            /* Balanced padding to keep the card comfortably off the edge */
            padding: 40px 20px; 
            box-sizing: border-box;
            background: radial-gradient(circle at 10% 20%, rgba(230, 30, 77, 0.1) 0%, transparent 50%),
                        radial-gradient(circle at 90% 80%, rgba(0, 166, 153, 0.15) 0%, transparent 50%),
                        linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            background-attachment: fixed;
        }

        /* --- GLOBAL & TYPOGRAPHY --- */
        .details-container {
            /* The Middle Ground: Wider than the original, but stops it from stretching infinitely */
            width: 100%; 
            max-width: 1400px; 
            margin: 0 auto;
            padding: 40px; 
            color: #222222;
            
            /* --- GLASSMORPHISM EFFECT --- */
            background: rgba(255, 255, 255, 0.55);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.05);
        }

        h1, h2, h3 { margin: 0; padding: 0; }
        
        .prop-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .prop-meta {
            font-size: 15px;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .meta-left { display: flex; gap: 12px; align-items: center; }
        .meta-left span { display: flex; align-items: center; gap: 4px; }
        .meta-link { text-decoration: underline; cursor: pointer; }
        
        .meta-right { display: flex; gap: 16px; font-weight: 600; }
        .meta-right div { display: flex; align-items: center; gap: 8px; cursor: pointer; text-decoration: underline; }

        /* --- 5-IMAGE MOSAIC GALLERY --- */
        .gallery-container {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            grid-template-rows: 250px 250px;
            gap: 12px;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 48px;
            position: relative;
        }

        .gal-img { width: 100%; height: 100%; object-fit: cover; cursor: pointer; transition: transform 0.3s, filter 0.3s; }
        .gal-img:hover { filter: brightness(0.85); transform: scale(1.02); }

        .gal-main { grid-column: 1 / 2; grid-row: 1 / 3; }
        .gal-2 { grid-column: 2 / 3; grid-row: 1 / 2; }
        .gal-3 { grid-column: 3 / 4; grid-row: 1 / 2; }
        .gal-4 { grid-column: 2 / 3; grid-row: 2 / 3; }
        .gal-5 { grid-column: 3 / 4; grid-row: 2 / 3; }

        .show-all-btn {
            position: absolute;
            bottom: 24px;
            right: 24px;
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.9);
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: 0.2s;
        }
        .show-all-btn:hover { background: rgba(255, 255, 255, 0.95); transform: translateY(-2px); }

        /* --- TWO-COLUMN LAYOUT --- */
        .content-split {
            display: flex;
            justify-content: space-between;
            gap: 80px;
        }

        /* LEFT SIDE: DETAILS */
        .left-details {
            flex: 1;
            max-width: 65%; 
        }

        .host-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 24px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }

        .host-title { font-size: 22px; font-weight: 600; margin-bottom: 4px; }
        .host-caps { font-size: 15px; color: #444; }
        .host-avatar { width: 56px; height: 56px; border-radius: 50%; object-fit: cover; background: #717171; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        .feature-list {
            display: flex;
            flex-direction: column;
            gap: 24px;
            padding-bottom: 24px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }

        .feature-item { display: flex; gap: 16px; }
        .feature-icon { font-size: 24px; width: 24px; margin-top: 4px; color: #E61E4D; }
        .feature-text h3 { font-size: 16px; font-weight: 600; margin-bottom: 4px; }
        .feature-text p { font-size: 14px; color: #555; margin: 0; line-height: 1.4; }

        .description-box {
            padding-bottom: 24px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            margin-bottom: 24px;
            font-size: 16px;
            line-height: 1.6;
            color: #333;
        }

        /* RIGHT SIDE: STICKY BOOKING WIDGET */
        .right-booking {
            width: 380px; 
            position: sticky;
            top: 120px; 
            align-self: flex-start;
        }

        .booking-card {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .booking-price {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .booking-price span { font-size: 16px; font-weight: 500; color: #444; }

        .booking-inputs {
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
        }

        .dates-row {
            display: flex;
            border-bottom: 1px solid rgba(0, 0, 0, 0.15);
        }

        .input-box {
            flex: 1;
            padding: 12px 10px;
            box-sizing: border-box; 
            overflow: hidden; 
        }
        .input-box:first-child { border-right: 1px solid rgba(0, 0, 0, 0.15); }
        
        .input-label { font-size: 10px; font-weight: 800; text-transform: uppercase; margin-bottom: 4px; color: #222; }
        .b-input { 
            width: 100%; 
            border: none; 
            outline: none; 
            font-size: 15px; 
            font-family: inherit; 
            font-weight: 500;
            box-sizing: border-box; 
            background: transparent;
            color: #222;
        }

        .reserve-btn {
            background: linear-gradient(135deg, #E61E4D 0%, #D70466 100%);
            color: white;
            width: 100%;
            padding: 16px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(230, 30, 77, 0.3);
        }
        .reserve-btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(230, 30, 77, 0.4); }

        .message-host-btn {
            background: rgba(255, 255, 255, 0.6);
            color: #222;
            width: 100%;
            padding: 14px 16px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            border: 1.5px solid rgba(0,0,0,0.15);
            cursor: pointer;
            transition: all 0.25s ease;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            text-decoration: none;
        }
        .message-host-btn:hover {
            background: rgba(255, 255, 255, 0.9);
            border-color: rgba(0,0,0,0.3);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        .price-breakdown { display: flex; flex-direction: column; gap: 12px; font-size: 16px; color: #333; padding-bottom: 16px; border-bottom: 1px solid rgba(0,0,0,0.1); margin-bottom: 16px; }
        .price-row { display: flex; justify-content: space-between; }
        .price-row.total { font-weight: 700; font-size: 18px; color: #222; }

        /* --- REVIEWS SECTION STYLES --- */
        .reviews-section {
            border-top: 1px solid rgba(0,0,0,0.1);
            padding-top: 48px;
            margin-top: 48px;
        }
        
        .reviews-header {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 32px;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 40px;
        }

        .review-card { 
            display: flex; flex-direction: column; gap: 12px; 
            background: rgba(255, 255, 255, 0.4);
            padding: 24px;
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.6);
        }
        
        .reviewer-info { display: flex; align-items: center; gap: 16px; }
        .reviewer-avatar {
            width: 50px; height: 50px; border-radius: 50%;
            background: linear-gradient(135deg, #222 0%, #444 100%); color: white;
            display: flex; justify-content: center; align-items: center;
            font-size: 18px; font-weight: 600;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .reviewer-name { font-size: 16px; font-weight: 600; margin-bottom: 2px; }
        .review-date { font-size: 14px; color: #555; }
        
        .review-stars { color: #E61E4D; font-size: 12px; display: flex; gap: 2px; }
        .review-text { font-size: 16px; line-height: 1.6; color: #333; word-wrap: break-word; }

        /* --- FULL SCREEN PHOTO MODAL --- */
        .photo-modal {
            display: none; 
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(255, 255, 255, 0.95); z-index: 9999; overflow-y: auto;
            backdrop-filter: blur(10px);
        }
        .photo-modal.show { display: block; }
        
        .photo-modal-header {
            position: sticky; top: 0; padding: 20px 40px; 
            background: transparent; z-index: 10000;
            display: flex; justify-content: space-between; align-items: center;
        }
        .close-photo-btn {
            background: white; border: 1px solid #ddd; font-size: 20px; 
            cursor: pointer; display: flex; align-items: center; gap: 8px; font-weight: 600;
            padding: 8px 16px; border-radius: 30px; transition: 0.2s;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .close-photo-btn:hover { background: #f0f0f0; transform: scale(1.05); }
        
        .photo-modal-content {
            max-width: 900px; margin: 0 auto; padding: 20px 20px 80px 20px;
            display: flex; flex-direction: column; gap: 32px;
        }
        .large-gallery-img {
            width: 100%; height: auto; border-radius: 16px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        @media (max-width: 900px) {
            .glass-wrapper { padding: 20px 10px; }
            .details-container { padding: 20px; }
            .content-split { flex-direction: column; gap: 40px; }
            .left-details { max-width: 100%; }
            .right-booking { width: 100%; position: static; }
            .gallery-container { grid-template-rows: 180px 180px; }
            .reviews-grid { grid-template-columns: 1fr; }
            .photo-modal-header { padding: 16px 20px; }
        }
    </style>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="glass-wrapper">
        <div class="details-container">
            
            <h1 class="prop-title"><asp:Label ID="lblTitle" runat="server" Text="Property Title"></asp:Label></h1>
            <div class="prop-meta">
                <div class="meta-left">
                    <span><i class="fas fa-star" style="font-size:14px; color:#E61E4D;"></i> <asp:Label ID="lblTopRating" runat="server" Text="New"></asp:Label></span>
                    <span>&middot;</span>
                    <span class="meta-link"><a href="#reviewsSection" style="color: inherit; text-decoration: inherit;"><asp:Label ID="lblTopReviewCount" runat="server" Text="0 reviews"></asp:Label></a></span>
                    <span>&middot;</span>
                    <span class="meta-link"><asp:Label ID="lblLocation" runat="server" Text="City, State, India"></asp:Label></span>
                    
                    <span>&middot;</span>
                    <span class="meta-link" style="color: #E61E4D; font-weight: 700;"><asp:Label ID="lblLocationType" runat="server" Text="Location Type"></asp:Label></span>
                </div>
                <div class="meta-right">
                    <div><i class="fas fa-arrow-up-from-bracket"></i> Share</div>
                    <div><i class="far fa-heart"></i> Save</div>
                </div>
            </div>

            <div class="gallery-container">
                <asp:Image ID="imgMain" runat="server" CssClass="gal-img gal-main" ImageUrl="https://via.placeholder.com/800x600" onclick="openPhotoModal()" />
                
                <asp:Image ID="img2" runat="server" CssClass="gal-img gal-2" ImageUrl="https://via.placeholder.com/400x300" onclick="openPhotoModal()" />
                <asp:Image ID="img3" runat="server" CssClass="gal-img gal-3" ImageUrl="https://via.placeholder.com/400x300" onclick="openPhotoModal()" />
                <asp:Image ID="img4" runat="server" CssClass="gal-img gal-4" ImageUrl="https://via.placeholder.com/400x300" onclick="openPhotoModal()" />
                <asp:Image ID="img5" runat="server" CssClass="gal-img gal-5" ImageUrl="https://via.placeholder.com/400x300" onclick="openPhotoModal()" />
                
                <button type="button" class="show-all-btn" onclick="openPhotoModal()"><i class="fas fa-th" style="margin-right:8px;"></i> Show all photos</button>
            </div>

            <div class="content-split">
                
                <div class="left-details">
                    
                    <div class="host-header">
                        <div>
                            <h2 class="host-title">Entire home hosted by <asp:Label ID="lblHostName" runat="server" Text="Housie"></asp:Label></h2>
                            <div class="host-caps">
                                <asp:Label ID="lblGuests" runat="server" Text="4"></asp:Label> guests &middot; 
                                <asp:Label ID="lblBedrooms" runat="server" Text="2"></asp:Label> bedrooms &middot; 
                                <asp:Label ID="lblBeds" runat="server" Text="2"></asp:Label> beds &middot; 
                                <asp:Label ID="lblBaths" runat="server" Text="2"></asp:Label> baths
                            </div>
                        </div>
                        
                        <asp:Image ID="imgHostAvatar" runat="server" CssClass="host-avatar" ImageUrl="https://via.placeholder.com/100" />
                    </div>

                    <div class="feature-list">
                        <div class="feature-item">
                            <div class="feature-icon"><i class="fas fa-door-open"></i></div>
                            <div class="feature-text">
                                <h3>Self check-in</h3>
                                <p>Check yourself in with the keypad.</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon"><i class="fas fa-medal"></i></div>
                            <div class="feature-text">
                                <h3>Housie is a Superhost</h3>
                                <p>Superhosts are experienced, highly rated hosts.</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon"><i class="far fa-calendar-times"></i></div>
                            <div class="feature-text">
                                <h3>Free cancellation for 48 hours.</h3>
                                <p>Get a full refund if you change your mind.</p>
                            </div>
                        </div>
                    </div>

                    <div class="description-box">
                        <asp:Label ID="lblDescription" runat="server" Text="This is a beautiful property located in the heart of the city..."></asp:Label>
                    </div>

                </div>

                <div class="right-booking">
                    <div class="booking-card">
                        
                        <div class="booking-price">
                            &#8377;<asp:Label ID="lblPrice" runat="server" Text="0"></asp:Label> <span>night</span>
                        </div>

                        <asp:HiddenField ID="hfBasePrice" runat="server" Value="0" />
                        <asp:HiddenField ID="hfBookedDates" runat="server" Value="" />
                        <asp:HiddenField ID="hfHostId" runat="server" Value="" />

                        <div class="booking-inputs">
                            <div class="dates-row">
                                <div class="input-box">
                                    <div class="input-label">Check-In</div>
                                    <asp:TextBox ID="txtCheckIn" runat="server" CssClass="b-input"></asp:TextBox>
                                </div>
                                <div class="input-box">
                                    <div class="input-label">Checkout</div>
                                    <asp:TextBox ID="txtCheckOut" runat="server" CssClass="b-input"></asp:TextBox>
                                </div>
                            </div>
                            <div class="input-box">
                                <div class="input-label">Guests</div>
                                <asp:DropDownList ID="ddlGuests" runat="server" CssClass="b-input">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <asp:Button ID="btnReserve" runat="server" Text="Reserve" CssClass="reserve-btn" OnClick="btnReserve_Click" />

                        <asp:Button ID="btnMessageHost" runat="server" 
                            Text="&#9993; Message Host"
                            CssClass="message-host-btn" 
                            OnClick="btnMessageHost_Click" />
                        
                        <div id="priceBreakdown" style="display: none;">
                            <div class="price-breakdown">
                                <div class="price-row">
                                    <span style="text-decoration: underline;" id="lblCalcText">&#8377;0 x 0 nights</span>
                                    <span id="lblCalcBaseTotal">&#8377;0</span>
                                </div>
                                <div class="price-row">
                                    <span style="text-decoration: underline;">Housie service fee</span>
                                    <span id="lblCalcServiceFee">&#8377;0</span>
                                </div>
                            </div>
                            
                            <div class="price-row total">
                                <span>Total amount</span>
                                <span id="lblCalcGrandTotal">&#8377;0</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

            <div class="reviews-section" id="reviewsSection">
                <div class="reviews-header">
                    <i class="fas fa-star" style="color: #E61E4D;"></i> 
                    <asp:Label ID="lblBottomRating" runat="server" Text="New"></asp:Label> &middot; 
                    <asp:Label ID="lblBottomReviewCount" runat="server" Text="0 reviews"></asp:Label>
                </div>

                <div class="reviews-grid">
                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-card">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar"><%# Eval("fname").ToString().Substring(0,1).ToUpper() %></div>
                                    <div>
                                        <div class="reviewer-name"><%# Eval("fname") %></div>
                                        <div class="review-date"><%# Convert.ToDateTime(Eval("reviewdate")).ToString("MMMM yyyy") %></div>
                                    </div>
                                </div>
                                
                                <div class="review-stars">
                                    <%# GetStars(Convert.ToInt32(Eval("rating"))) %>
                                </div>

                                <div class="review-text">
                                    <%# Eval("reviewtext") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <asp:Label ID="lblNoReviews" runat="server" Visible="false" CssClass="review-text" style="color: #717171;" Text="No reviews yet. Be the first to review this property after your stay!"></asp:Label>
            </div>

        </div>
    </div>

    <div id="fullPhotoModal" class="photo-modal">
        <div class="photo-modal-header">
            <button type="button" class="close-photo-btn" onclick="closePhotoModal()"><i class="fas fa-chevron-left"></i> Back</button>
            <div style="font-size: 16px; font-weight: 600;">Photo Gallery</div>
            <div style="width: 80px;"></div> 
        </div>
        <div class="photo-modal-content" id="modalImageInjectArea">
            </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            var bookedDatesString = document.getElementById('<%= hfBookedDates.ClientID %>').value;
            var disableDates = bookedDatesString ? bookedDatesString.split(',') : [];

            var checkoutPicker = flatpickr("#<%= txtCheckOut.ClientID %>", {
                minDate: "today",
                disable: disableDates,
                dateFormat: "Y-m-d",
                onChange: function() {
                    calculatePrice(); 
                }
            });

            flatpickr("#<%= txtCheckIn.ClientID %>", {
                minDate: "today",
                disable: disableDates,
                dateFormat: "Y-m-d",
                onChange: function(selectedDates, dateStr, instance) {
                    if(selectedDates.length > 0) {
                        var nextDay = new Date(selectedDates[0]);
                        nextDay.setDate(nextDay.getDate() + 1);
                        checkoutPicker.set("minDate", nextDay);
                    }
                    calculatePrice(); 
                }
            });
        });

        // --- PHOTO MODAL LOGIC ---
        function openPhotoModal() {
            var injectArea = document.getElementById('modalImageInjectArea');
            injectArea.innerHTML = ''; 
            
            var galleryImages = document.querySelectorAll('.gallery-container .gal-img');
            
            galleryImages.forEach(function(img) {
                if(!img.src.includes('placeholder.com')) {
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

        // --- CALCULATION LOGIC ---
        function calculatePrice() {
            var checkInStr = document.getElementById('<%= txtCheckIn.ClientID %>').value;
            var checkOutStr = document.getElementById('<%= txtCheckOut.ClientID %>').value;
            var breakdownDiv = document.getElementById('priceBreakdown');

            if (!checkInStr || !checkOutStr) {
                breakdownDiv.style.display = 'none';
                return;
            }

            var checkIn = new Date(checkInStr);
            var checkOut = new Date(checkOutStr);

            if (checkOut <= checkIn) {
                document.getElementById('<%= txtCheckOut.ClientID %>').value = "";
                breakdownDiv.style.display = 'none';
                return;
            }

            var bookedDatesStr = document.getElementById('<%= hfBookedDates.ClientID %>').value;
            if (bookedDatesStr) {
                var bookedArray = bookedDatesStr.split(',');
                
                var currentDate = new Date(checkIn);
                while (currentDate < checkOut) {
                    var dateStr = currentDate.toISOString().split('T')[0];
                    if (bookedArray.includes(dateStr)) {
                        alert("Oops! Your selected range overlaps with dates that are already booked. Please adjust your checkout date.");
                        document.getElementById('<%= txtCheckOut.ClientID %>').value = "";
                        breakdownDiv.style.display = 'none';
                        return;
                    }
                    currentDate.setDate(currentDate.getDate() + 1);
                }
            }

            var timeDiff = checkOut.getTime() - checkIn.getTime();
            var nights = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
            
            var basePrice = parseFloat(document.getElementById('<%= hfBasePrice.ClientID %>').value);
            var baseTotal = nights * basePrice;
            var serviceFee = baseTotal * 0.10;
            var grandTotal = baseTotal + serviceFee;

            var formatter = new Intl.NumberFormat('en-IN');

            document.getElementById('lblCalcText').innerText = "\u20B9" + formatter.format(basePrice) + " x " + nights + (nights === 1 ? " night" : " nights");
            document.getElementById('lblCalcBaseTotal').innerText = "\u20B9" + formatter.format(baseTotal);
            document.getElementById('lblCalcServiceFee').innerText = "\u20B9" + formatter.format(serviceFee);
            document.getElementById('lblCalcGrandTotal').innerText = "\u20B9" + formatter.format(grandTotal);

            breakdownDiv.style.display = 'block';
        }
    </script>
</asp:Content>