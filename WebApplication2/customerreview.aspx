<%@ Page Title="Leave a Review - Housie" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customerreview.aspx.cs" Inherits="WebApplication2.customerreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        /* HIDE LOGO HACK */
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        /* --- LUMINOUS EDITORIAL BACKGROUND --- */
        body {
            font-family: 'Inter', sans-serif;
            color: #2d2f2f; 
            margin: 0; 
            background-color: #f6f6f6;
            background-image: 
                radial-gradient(at 0% 0%, rgba(185, 0, 56, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(106, 70, 174, 0.15) 0px, transparent 50%),
                radial-gradient(at 50% 100%, rgba(255, 116, 131, 0.1) 0px, transparent 50%);
            background-attachment: fixed; 
            background-repeat: no-repeat;
        }

        h1, h2, h3, .font-headline { font-family: 'Plus Jakarta Sans', sans-serif; }

        /* --- GLASSMORPHISM CONTAINER --- */
        .review-container {
            max-width: 650px;
            margin: 60px auto 100px auto;
            padding: 50px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.7) 0%, rgba(255, 255, 255, 0.3) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            -webkit-backdrop-filter: blur(25px) saturate(120%);
            border-top: 1.5px solid rgba(255, 255, 255, 0.9);
            border-left: 1.5px solid rgba(255, 255, 255, 0.9);
            border-bottom: 1.5px solid rgba(0, 0, 0, 0.1);
            border-right: 1.5px solid rgba(0, 0, 0, 0.1);
            border-radius: 2.5rem;
            box-shadow: 10px 10px 30px rgba(0,0,0,0.08), -10px -10px 30px rgba(255,255,255,0.8), inset 2px 2px 10px rgba(255, 255, 255, 0.5);
            color: #2d2f2f;
            box-sizing: border-box;
        }

        .back-link { 
            display: inline-flex; align-items: center; gap: 8px; margin-bottom: 32px; 
            color: #b90038; text-decoration: none; font-weight: 700; font-size: 14px; 
            transition: transform 0.2s; 
        }
        .back-link:hover { transform: translateX(-4px); }

        .page-title { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 2.5rem; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.05em; color: #2d2f2f; text-shadow: 1px 1px 0px rgba(255,255,255,0.8); }
        .page-subtitle { font-size: 16px; color: #5a5c5c; margin-bottom: 40px; font-weight: 500; }

        /* --- PROPERTY PREVIEW BLOCK --- */
        .prop-preview {
            display: flex; gap: 20px; padding: 20px; 
            background: rgba(255, 255, 255, 0.5); border-radius: 1.5rem; margin-bottom: 40px;
            align-items: center;
            box-shadow: inset 2px 2px 8px rgba(0,0,0,0.05), inset -2px -2px 8px rgba(255,255,255,0.6);
            border: 1px solid rgba(255,255,255,0.6);
        }
        .prop-img { width: 80px; height: 80px; border-radius: 12px; object-fit: cover; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .prop-info { flex: 1; }
        .prop-title { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 800; margin-bottom: 4px; color: #2d2f2f; letter-spacing: -0.02em; }
        .prop-dates { font-size: 14px; color: #5a5c5c; font-weight: 500; }

        .section-label { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 700; margin-bottom: 16px; display: block; color: #2d2f2f; letter-spacing: -0.02em; }

        /* --- INTERACTIVE STAR RATING --- */
        .star-rating {
            display: flex; flex-direction: row-reverse; justify-content: flex-end;
            gap: 8px; margin-bottom: 40px;
        }
        .star-rating input { display: none; }
        .star-rating label {
            font-size: 45px; color: rgba(0,0,0,0.1); cursor: pointer; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            text-shadow: 1px 1px 0 rgba(255,255,255,0.8);
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #FFB400; /* Vibrant Gold */
            text-shadow: 0 4px 15px rgba(255, 180, 0, 0.5);
            transform: scale(1.15);
        }

        /* --- RECESSED TEXT AREA --- */
        .review-textarea {
            width: 100%; height: 160px; padding: 20px;
            background: rgba(230, 235, 240, 0.4);
            border-top: 1px solid rgba(0,0,0,0.08);
            border-left: 1px solid rgba(0,0,0,0.08);
            border-bottom: 1px solid rgba(255,255,255,0.8);
            border-right: 1px solid rgba(255,255,255,0.8);
            border-radius: 16px; font-size: 15px; font-family: 'Inter', sans-serif; font-weight: 500;
            resize: vertical; box-sizing: border-box; margin-bottom: 32px;
            box-shadow: inset 4px 4px 10px rgba(0,0,0,0.06), inset -4px -4px 10px rgba(255,255,255,0.8);
            color: #2d2f2f;
            transition: all 0.2s;
        }
        .review-textarea:focus { 
            outline: none; 
            background: rgba(255,255,255,0.7); 
            box-shadow: inset 2px 2px 5px rgba(0,0,0,0.05), 0 0 0 3px rgba(185,0,56,0.2); 
        }
        .review-textarea::placeholder { color: rgba(0,0,0,0.4); }

        /* --- PHYSICAL 3D SUBMIT BUTTON --- */
        .btn-submit {
            background: linear-gradient(180deg, #FA4871 0%, #D70466 100%);
            color: white; border: 1px solid #A8004E; border-top: 1px solid #FF8AA9;
            padding: 16px 32px; border-radius: 16px;
            font-size: 18px; font-weight: 700; font-family: 'Plus Jakarta Sans', sans-serif;
            cursor: pointer; width: 100%;
            box-shadow: 0 6px 0 #A8004E, 0 12px 20px rgba(230, 30, 77, 0.3);
            transition: all 0.1s ease;
            text-shadow: 0 -1px 0 rgba(0,0,0,0.2);
            margin-top: 10px;
        }
        .btn-submit:active { 
            transform: translateY(6px); 
            box-shadow: 0 0 0 #A8004E, inset 0 4px 8px rgba(0,0,0,0.4); 
        }

        .val-error { 
            color: #b90038; font-size: 14px; display: block; margin-top: -24px; margin-bottom: 24px; 
            font-weight: 700; background: rgba(185, 0, 56, 0.1); padding: 8px 16px; border-radius: 8px;
            border-left: 3px solid #b90038;
        }

        @media (max-width: 768px) {
            .review-container { margin: 30px 15px; padding: 30px 20px; border-radius: 1.5rem; }
            .page-title { font-size: 2rem; }
            .star-rating label { font-size: 36px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="review-container">
        
        <a href="customertrips.aspx" class="back-link"><i class="fas fa-chevron-left"></i> Back to trips</a>
        
        <div class="page-title">Rate your stay</div>
        <div class="page-subtitle">Share your experience to help others.</div>

        <div class="prop-preview">
            <asp:Image ID="imgProperty" runat="server" CssClass="prop-img" ImageUrl="https://via.placeholder.com/100" />
            <div class="prop-info">
                <div class="prop-title"><asp:Label ID="lblPropTitle" runat="server" Text="Property Name"></asp:Label></div>
                <div class="prop-dates">Stayed: <asp:Label ID="lblDates" runat="server" Text="..."></asp:Label></div>
            </div>
        </div>

        <asp:HiddenField ID="hfRatingScore" runat="server" Value="0" />

        <label class="section-label">Overall rating</label>
        <div class="star-rating">
            <input type="radio" id="star5" name="rating" value="5" onclick="setRating(5)" /><label for="star5" class="fas fa-star"></label>
            <input type="radio" id="star4" name="rating" value="4" onclick="setRating(4)" /><label for="star4" class="fas fa-star"></label>
            <input type="radio" id="star3" name="rating" value="3" onclick="setRating(3)" /><label for="star3" class="fas fa-star"></label>
            <input type="radio" id="star2" name="rating" value="2" onclick="setRating(2)" /><label for="star2" class="fas fa-star"></label>
            <input type="radio" id="star1" name="rating" value="1" onclick="setRating(1)" /><label for="star1" class="fas fa-star"></label>
        </div>

        <label class="section-label">Write a public review</label>
        <asp:TextBox ID="txtReview" runat="server" CssClass="review-textarea" TextMode="MultiLine" placeholder="What did you love about this place? Was there anything that could be improved?"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvReview" runat="server" ControlToValidate="txtReview" 
            ErrorMessage="Please write a brief review." CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>

        <asp:Button ID="btnSubmitReview" runat="server" Text="Submit review" CssClass="btn-submit" OnClick="btnSubmitReview_Click" OnClientClick="return validateRating();" />

    </div>

    <script>
        // Update the hidden ASP.NET field when a star is clicked
        function setRating(score) {
            document.getElementById('<%= hfRatingScore.ClientID %>').value = score;
        }

        // Prevent submission if they haven't selected any stars
        function validateRating() {
            var score = document.getElementById('<%= hfRatingScore.ClientID %>').value;
            if (score === "0" || score === "") {
                alert("Please select a star rating before submitting!");
                return false;
            }
            return true;
        }
    </script>
</asp:Content>