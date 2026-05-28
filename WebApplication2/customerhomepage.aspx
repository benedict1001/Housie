<%@ Page Title="Housie" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customerhomepage.aspx.cs" Inherits="WebApplication2.customerhomepage" %>
<%@ OutputCache Duration="60" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <style>
        /* HIDE LOGO HACK */
        .brand-logo-link svg, .header-logo, .logo-img { display: none !important; }

        /* --- LUMINOUS EDITORIAL BACKGROUND & TYPOGRAPHY --- */
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
        
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* --- SKELETON LOADING STYLES --- */
        .skeleton {
            background: #e2e5e7;
            background-image: linear-gradient(90deg, rgba(255, 255, 255, 0), rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0));
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite linear;
            border-radius: 8px;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        /* Skeleton Card Structure (Matching your property-card) */
        .skeleton-wrapper { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 40px; width: 100%; }
        .skeleton-card { width: 100%; display: flex; flex-direction: column; }
        .skel-img { width: 100%; aspect-ratio: 4 / 5; border-radius: 1.5rem; margin-bottom: 24px; }
        .skel-title-row { display: flex; justify-content: space-between; margin-bottom: 8px; padding: 0 8px; }
        .skel-title { height: 22px; width: 60%; }
        .skel-rating { height: 22px; width: 15%; }
        .skel-subtitle { height: 16px; width: 45%; margin-bottom: 16px; margin-left: 8px; }
        .skel-price { height: 22px; width: 35%; margin-left: 8px; }

        /* Hide real content initially */
        .real-content-hidden { display: none !important; }

        /* --- HERO SECTION --- */
        .hero-container {
            padding: 40px 40px;
            width: 100%;
            box-sizing: border-box;
            margin: 0 auto;
            position: relative;
            z-index: 50; 
        }

        .hero-banner {
            position: relative; 
            width: 100%; 
            height: 614px; 
            min-height: 500px;
            border-radius: 2.5rem;
            box-shadow: 0 4px 12px rgba(185, 0, 56, 0.04), 0 20px 40px rgba(0, 0, 0, 0.06);
            background-image: url('https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?q=80&w=2070&auto=format&fit=crop');
            background-size: cover; 
            background-position: center;
        }

        .hero-overlay { 
            position: absolute; top: 0; left: 0; right: 0; bottom: 0; 
            background: linear-gradient(to top, rgba(0,0,0,0.6), transparent, transparent); 
            z-index: 1; 
            border-radius: 2.5rem; /* Keeps corners rounded */
        }

        .hero-content {
            position: absolute; inset: 0;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            text-align: center; padding: 0 24px; z-index: 20; 
        }

        .hero-title { 
            font-size: clamp(3rem, 5vw, 4.5rem); 
            font-weight: 800; 
            color: white; 
            letter-spacing: -0.05em; 
            margin-bottom: 2rem; 
            text-shadow: 0 10px 20px rgba(0,0,0,0.3); 
            line-height: 1.1;
        }
        .hero-title span { color: #ff7483; }

        /* --- GLASS SEARCH PILL --- */
        .search-bar-container {
            display: flex; align-items: center;
            position: relative; /* Added so dropdowns attach correctly */
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 9999px; 
            padding: 8px;
            width: 100%; max-width: 800px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            transition: all 0.2s ease;
        }

        .search-bar-container.sticky {
            position: fixed; 
            top: 105px; /* Adjusted to leave a perfect half-gap below the header */
            left: 50%;
            width: 90%; 
            max-width: 850px;
            background: rgba(220, 225, 230, 0.45); 
            backdrop-filter: blur(30px) saturate(140%);
            -webkit-backdrop-filter: blur(30px) saturate(140%);
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15), inset 0 0 10px rgba(255,255,255,0.4);
            z-index: 1050;
            animation: popDown 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.1) forwards;
        }

        @keyframes popDown {
            0% { top: -100px; transform: translateX(-50%) scale(0.9); opacity: 0; }
            100% { top: 105px; transform: translateX(-50%) scale(1); opacity: 1; } /* Matches new top gap */
        }

        .search-section { 
            display: flex; align-items: center; flex: 1; padding: 0 24px; 
            border-right: 1px solid rgba(255,255,255,0.2); 
            transition: background 0.2s;
            border-radius: 40px;
        }
        .search-section:last-of-type { border-right: none; }
        .search-section:hover { background: rgba(255,255,255,0.6); }
        .search-section.active-section { background: rgba(255,255,255,0.95); box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        .search-icon { color: #E61E4D; margin-right: 12px; font-size: 26px; }
        
        .search-text-block { display: flex; flex-direction: column; text-align: left; width: 100%; }
        .search-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: rgba(0,0,0,0.5); margin-bottom: 2px; }
        
        .search-input { 
            border: none; background: transparent; outline: none; 
            font-size: 15px; font-weight: 700; color: #222; width: 100%; padding: 0; font-family: 'Inter', sans-serif;
            cursor: pointer;
        }
        .search-input::placeholder { color: rgba(0, 0, 0, 0.3); }

        /* --- GUEST STEPPER UI --- */
        .guest-stepper {
            display: flex; align-items: center; gap: 12px; margin-top: 2px;
        }
        .stepper-btn {
            width: 24px; height: 24px; border-radius: 50%;
            border: 1px solid #b3b3b3; background: transparent;
            color: #5a5c5c; display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 16px; font-weight: 500; transition: all 0.2s;
            padding: 0;
        }
        .stepper-btn:hover { border-color: #222; color: #222; }
        .guest-display { font-size: 15px; font-weight: 700; color: #222; min-width: 12px; text-align: center; }

        .search-btn {
            background: linear-gradient(135deg, #FA4871 0%, #D70466 100%);
            color: white; border-radius: 50%; width: 56px; height: 56px; 
            display: flex; align-items: center; justify-content: center;
            border: none; cursor: pointer; 
            box-shadow: 0 8px 15px -3px rgba(230, 30, 77, 0.4);
            transition: transform 0.2s;
        }
        .search-btn:hover { transform: scale(1.05); }

        /* --- AIRBNB DESTINATION DROPDOWN --- */
        .where-dropdown {
            display: none; 
            position: absolute; 
            top: 100%; 
            left: 0; 
            width: 100%; 
            max-width: 420px;
            margin-top: 20px; 
            background: #ffffff; 
            border-radius: 32px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15); 
            padding: 24px 16px; 
            z-index: 9999; 
            max-height: 450px; 
            overflow-y: auto;
            text-align: left;
            cursor: default;
        }
        
        .where-dropdown.show { display: block; animation: fadeInPop 0.2s ease-out; }
        .where-dropdown::-webkit-scrollbar { width: 8px; }
        .where-dropdown::-webkit-scrollbar-thumb { background-color: #dddddd; border-radius: 4px; }

        .dropdown-item {
            display: flex; align-items: center; gap: 16px; padding: 12px 16px; 
            border-radius: 16px; cursor: pointer; transition: background 0.2s;
        }
        .dropdown-item:hover { background: #f7f7f7; }

        .item-icon {
            width: 48px; height: 48px; background: #f1f5f9; border-radius: 12px; 
            display: flex; align-items: center; justify-content: center; font-size: 24px; color: #64748b; flex-shrink: 0;
            border: 1px solid #e2e8f0;
        }
        .dropdown-item:hover .item-icon { border-color: #cbd5e1; color: #E61E4D; }

        .item-text { display: flex; flex-direction: column; }
        .item-title { font-size: 15px; font-weight: 600; color: #222222; margin-bottom: 2px; }
        .item-subtitle { font-size: 13px; color: #717171; font-weight: 500; }

        /* --- CUSTOM AIRBNB STYLE DATE PICKER --- */
        .date-dropdown {
            display: none; 
            position: absolute; 
            top: 100%; 
            left: 50%;
            transform: translateX(-50%); 
            margin-top: 20px; 
            background: #ffffff; 
            border-radius: 32px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15); 
            padding: 32px; 
            width: 800px;
            z-index: 9999; 
            cursor: default;
            text-align: center;
        }
        
        .date-dropdown.show { display: block; animation: fadeInPop 0.2s ease-out; }
        
        .dropdown-anchor { position: relative; }

        @keyframes fadeInPop {
            0% { opacity: 0; transform: translate(-50%, -10px) scale(0.98); }
            100% { opacity: 1; transform: translate(-50%, 0) scale(1); }
        }

        .date-tabs { display: inline-flex; background: #ebebeb; border-radius: 32px; padding: 4px; margin-bottom: 30px; }
        .date-tab { padding: 10px 30px; border-radius: 32px; font-weight: 600; font-size: 15px; color: #222; cursor: pointer; transition: 0.2s; }
        .date-tab:hover { background: #e0e0e0; }
        .date-tab.active { background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; }

        .dropdown-title { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 800; font-size: 20px; margin-bottom: 20px; color: #222; }
        .stay-pills { display: flex; justify-content: center; gap: 12px; margin-bottom: 40px; }
        .stay-pill { border: 1px solid #ddd; padding: 12px 24px; border-radius: 32px; font-size: 15px; font-weight: 500; color: #222; cursor: pointer; transition: 0.2s; }
        .stay-pill:hover { border-color: #222; }
        .stay-pill.active { border-color: #222; background: #f7f7f9; font-weight: 600; }
        .month-carousel { display: flex; gap: 16px; overflow-x: auto; padding: 10px 5px 20px 5px; scrollbar-width: none; }
        .month-card { border: 1px solid #ddd; border-radius: 20px; padding: 24px 20px; min-width: 130px; display: flex; flex-direction: column; align-items: center; cursor: pointer; transition: 0.2s; flex-shrink: 0; background: #fff; }
        .month-card:hover { border-color: #222; }
        .month-card.active { border-color: #222; background: #f7f7f9; box-shadow: inset 0 0 0 1px #222; }
        .month-card .material-symbols-outlined { font-size: 36px; color: #222; margin-bottom: 12px; }
        .m-name { font-weight: 700; font-size: 16px; color: #222; }
        .m-year { color: #717171; font-size: 14px; }

        .calendar-container { display: flex; justify-content: space-between; gap: 40px; padding: 0 20px; }
        .calendar-month { flex: 1; text-align: left; }
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .cal-title { font-weight: 600; font-size: 16px; color: #222; }
        .cal-nav { cursor: pointer; color: #222; }
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; text-align: center; }
        .cal-day-name { font-size: 12px; color: #717171; font-weight: 600; padding: 10px 0; }
        .cal-day { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 600; color: #222; border-radius: 50%; cursor: pointer; }
        .cal-day:hover { background: #f0f0f0; }
        .cal-day.disabled { color: #ddd; cursor: not-allowed; }
        .cal-day.disabled:hover { background: none; }
        .cal-day.selected { background: #222; color: #fff; }

        .exact-dates-footer { display: flex; justify-content: center; gap: 10px; margin-top: 30px; }
        .exact-pill { border: 1px solid #ddd; padding: 8px 16px; border-radius: 32px; font-size: 13px; color: #222; display: flex; align-items: center; gap: 6px; cursor: pointer;}
        .exact-pill:hover { border-color: #222; }

        /* --- CATEGORY CHIPS --- */
        .category-scroll {
            display: flex; gap: 16px; margin: 40px auto 60px auto; 
            width: 100%; padding: 0 40px 10px 40px; box-sizing: border-box; 
            overflow-x: auto; scrollbar-width: none;
        }
        .category-scroll::-webkit-scrollbar { display: none; }
        
        .cat-chip {
            display: flex; align-items: center; gap: 8px;
            background: #e1e3e3; color: #5a5c5c;
            padding: 12px 24px; border-radius: 9999px;
            font-weight: 600; font-size: 15px; white-space: nowrap;
            transition: background 0.2s; cursor: pointer;
        }
        .cat-chip:hover { background: rgba(255,255,255,0.6); }
        .cat-chip.active { background: rgba(255, 116, 131, 0.2); color: #b90038; }

        /* --- AI CHATBOT GLASS BUTTON --- */
        .ai-chip {
            display: flex; align-items: center; gap: 8px;
            background: rgba(230, 30, 77, 0.15); 
            backdrop-filter: blur(12px); 
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(230, 30, 77, 0.3);
            color: #b90038;
            padding: 12px 24px; border-radius: 9999px;
            font-weight: 700; font-size: 15px; white-space: nowrap;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(230, 30, 77, 0.1);
        }
        
        .ai-chip:hover {
            background: rgba(230, 30, 77, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 30, 77, 0.2);
            color: #b90038;
        }

        .ai-chip .material-symbols-outlined {
            animation: pulse-glow 2s infinite ease-in-out;
            color: #E61E4D;
        }

        @keyframes pulse-glow {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.15); opacity: 0.8; }
        }

        /* --- EDITORIAL GLASS CONTAINER --- */
        .section-container { 
            position: relative; z-index: 5; padding: 50px 60px; 
            width: 100%; box-sizing: border-box;
            margin: 0 auto 60px auto; 
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 2.5rem; 
        }

        .section-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 48px; }
        .section-eyebrow { font-family: 'Inter', sans-serif; font-size: 12px; font-weight: 800; letter-spacing: 0.2em; color: #b90038; text-transform: uppercase; margin-bottom: 8px; }
        .section-title { font-size: 2.5rem; font-weight: 800; color: #2d2f2f; letter-spacing: -0.05em; margin: 0; }
        
        .grid-wrapper { 
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 40px; 
        }

        /* --- LUMINOUS PROPERTY CARDS --- */
        .property-card { 
            text-decoration: none; color: inherit; display: block;
            cursor: pointer;
        }
        
        .img-container { 
            position: relative; width: 100%; aspect-ratio: 4 / 5; 
            border-radius: 1.5rem; overflow: hidden; margin-bottom: 24px; 
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .property-card:hover .img-container { transform: translateY(-8px); }
        
        .prop-img { 
            width: 100%; height: 100%; object-fit: cover; 
            transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1); 
        }
        .property-card:hover .prop-img { transform: scale(1.1); }
        
        .fav-btn { 
            position: absolute; top: 16px; right: 16px; 
            background: rgba(255,255,255,0.2); backdrop-filter: blur(12px); 
            color: white; border: none; border-radius: 50%; width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center; cursor: pointer;
            transition: background 0.2s; z-index: 10;
        }
        .fav-btn:hover { background: #b90038; }

        .card-body { padding: 0 8px; }
        .card-top-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
        .card-title { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 700; color: #2d2f2f; }
        
        .card-rating { display: flex; align-items: center; gap: 4px; font-weight: 700; font-size: 14px; }
        .card-rating .material-symbols-outlined { color: #b90038; font-size: 18px; font-variation-settings: 'FILL' 1; }
        
        .card-subtitle { font-size: 14px; color: #5a5c5c; margin-bottom: 16px; }
        
        .card-price { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 20px; font-weight: 800; color: #2d2f2f; }
        .card-price span { font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 500; color: #5a5c5c; }

        /* --- CALL TO ACTION (CTA) SECTION --- */
        .cta-section {
            display: flex; gap: 30px; max-width: 1400px; margin: 0 auto 80px auto; padding: 0 40px; box-sizing: border-box;
        }

        .cta-card {
            flex: 1; border-radius: 2.5rem; min-height: 380px; position: relative; overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.06); display: flex; flex-direction: column;
            justify-content: flex-end; padding: 40px; box-sizing: border-box;
        }

        .cta-host {
            background-image: url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=2075&auto=format&fit=crop');
            background-size: cover; background-position: center;
        }

        .cta-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.8), rgba(0,0,0,0.2), transparent); z-index: 1;
        }

        .cta-login {
            background: linear-gradient(135deg, rgba(255, 240, 243, 0.95) 0%, rgba(255, 224, 230, 0.7) 100%);
            backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.8);
            justify-content: center; 
        }

        .cta-content { position: relative; z-index: 2; }
        
        .cta-title { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 2.2rem; font-weight: 800; color: white; margin-bottom: 12px; letter-spacing: -0.02em; }
        .cta-desc { font-size: 1.1rem; color: rgba(255,255,255,0.9); margin-bottom: 28px; max-width: 80%; line-height: 1.5; }
        
        .cta-title.dark-text { color: #2d2f2f; }
        .cta-desc.dark-text { color: #5a5c5c; }

        .cta-btn-group { display: flex; gap: 16px; flex-wrap: wrap; }

        .cta-btn {
            display: inline-block; padding: 14px 32px; border-radius: 12px; font-weight: 700; font-size: 15px;
            text-decoration: none; transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; text-align: center;
        }
        .cta-btn:hover { transform: translateY(-2px); }

        .cta-btn-white { background: white; color: #b90038; box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .cta-btn-white:hover { box-shadow: 0 12px 25px rgba(0,0,0,0.15); }

        .cta-btn-primary { background: #b90038; color: white; box-shadow: 0 8px 20px rgba(185, 0, 56, 0.3); border: 1px solid #b90038; }
        .cta-btn-primary:hover { box-shadow: 0 12px 25px rgba(185, 0, 56, 0.4); color: white; }

        .cta-btn-outline { background: transparent; color: #b90038; border: 2px solid #b90038; }
        .cta-btn-outline:hover { background: rgba(185, 0, 56, 0.05); }

        @media (max-width: 900px) {
            .hero-title { font-size: 2.5rem; }
            .hero-container { padding: 20px 15px; }
            .section-container { padding: 30px 20px; border-radius: 1.5rem; }
            .search-bar-container.sticky { top: 70px; } /* Adjusted for mobile */
            .search-bar-container { flex-direction: column; border-radius: 24px; padding: 16px; gap: 16px; }
            .search-section { border-right: none; border-bottom: 1px solid rgba(255,255,255,0.2); padding: 12px 0; width: 100%; }
            .search-section:last-of-type { border-bottom: none; }
            .search-btn { width: 100%; border-radius: 12px; }
            .section-header { flex-direction: column; align-items: flex-start; gap: 16px; }
            
            /* CTA Mobile */
            .cta-section { flex-direction: column; padding: 0 20px; }
            .cta-card { min-height: 300px; padding: 30px; }
            .cta-title { font-size: 1.8rem; }
            .cta-desc { max-width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="hero-container">
        <div class="hero-banner">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h1 class="hero-title">Find your next <br/><span>dream escape.</span></h1>

                <div class="dropdown-anchor">
                    <div class="search-bar-container" id="mainSearchBar">
                        
                        <div class="search-section" id="whereSection" style="cursor: pointer;">
                            <span class="material-symbols-outlined search-icon">location_on</span>
                            <div class="search-text-block">
                                <span class="search-label">Where</span>
                                
                                <div style="display: none;">
                                    <asp:DropDownList ID="ddlLocation" runat="server"></asp:DropDownList>
                                </div>
                                
                                <input type="text" id="whereInput" class="search-input" placeholder="Search destinations" readonly style="pointer-events: none; background: transparent;" />
                            </div>
                        </div>
                        <div class="search-divider" style="height: 32px; width: 1px; background: rgba(0,0,0,0.1); margin: 0 10px;"></div>
                        
                        <div class="search-section" id="whenSection" style="cursor: pointer;">
                            <span class="material-symbols-outlined search-icon">calendar_month</span>
                            <div class="search-text-block">
                                <span class="search-label">When</span>
                                <asp:TextBox ID="txtWhen" runat="server" CssClass="search-input" placeholder="Add dates" AutoCompleteType="Disabled" style="pointer-events: none; background: transparent;"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="search-divider" style="height: 32px; width: 1px; background: rgba(0,0,0,0.1); margin: 0 10px;"></div>
                        
                        <div class="search-section">
                            <span class="material-symbols-outlined search-icon">group</span>
                            <div class="search-text-block">
                                <span class="search-label">Who</span>
                                
                                <div class="guest-stepper">
                                    <button type="button" class="stepper-btn" onclick="updateGuests(-1, event)">-</button>
                                    <span id="guestCountDisplay" class="guest-display">1</span>
                                    <button type="button" class="stepper-btn" onclick="updateGuests(1, event)">+</button>
                                </div>

                                <div style="display: none;">
                                    <asp:TextBox ID="txtGuestNo" runat="server" Text="1"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:LinkButton ID="btnSearch" runat="server" CssClass="search-btn" OnClick="btnSearch_Click">
                            <span class="material-symbols-outlined">search</span>
                        </asp:LinkButton>
                        
                        <div id="whereDropdown" class="where-dropdown">
                            </div>
                        
                        <div id="dateDropdown" class="date-dropdown">
                            <div class="date-tabs">
                                <div class="date-tab active" onclick="switchTab('dates')">Dates</div>
                                <div class="date-tab" onclick="switchTab('flexible')">Flexible</div>
                            </div>
                            
                            <div id="tabDates" class="tab-content active">
                                <div class="calendar-container">
                                    <div class="calendar-month">
                                        <div class="cal-header">
                                            <span class="material-symbols-outlined cal-nav">chevron_left</span>
                                            <div class="cal-title">April 2026</div>
                                            <div style="width: 24px;"></div>
                                        </div>
                                        <div class="cal-grid">
                                            <div class="cal-day-name">S</div><div class="cal-day-name">M</div><div class="cal-day-name">T</div><div class="cal-day-name">W</div><div class="cal-day-name">T</div><div class="cal-day-name">F</div><div class="cal-day-name">S</div>
                                            <div></div><div></div><div></div><div class="cal-day disabled">1</div><div class="cal-day disabled">2</div><div class="cal-day disabled">3</div><div class="cal-day disabled">4</div>
                                            <div class="cal-day disabled">5</div><div class="cal-day disabled">6</div><div class="cal-day disabled">7</div><div class="cal-day" onclick="selectDate('2026-04-08', this)">8</div><div class="cal-day" onclick="selectDate('2026-04-09', this)">9</div><div class="cal-day" onclick="selectDate('2026-04-10', this)">10</div><div class="cal-day" onclick="selectDate('2026-04-11', this)">11</div>
                                            <div class="cal-day" onclick="selectDate('2026-04-12', this)">12</div><div class="cal-day" onclick="selectDate('2026-04-13', this)">13</div><div class="cal-day" onclick="selectDate('2026-04-14', this)">14</div><div class="cal-day" onclick="selectDate('2026-04-15', this)">15</div><div class="cal-day" onclick="selectDate('2026-04-16', this)">16</div><div class="cal-day" onclick="selectDate('2026-04-17', this)">17</div><div class="cal-day" onclick="selectDate('2026-04-18', this)">18</div>
                                            <div class="cal-day" onclick="selectDate('2026-04-19', this)">19</div><div class="cal-day" onclick="selectDate('2026-04-20', this)">20</div><div class="cal-day" onclick="selectDate('2026-04-21', this)">21</div><div class="cal-day" onclick="selectDate('2026-04-22', this)">22</div><div class="cal-day" onclick="selectDate('2026-04-23', this)">23</div><div class="cal-day" onclick="selectDate('2026-04-24', this)">24</div><div class="cal-day" onclick="selectDate('2026-04-25', this)">25</div>
                                            <div class="cal-day" onclick="selectDate('2026-04-26', this)">26</div><div class="cal-day" onclick="selectDate('2026-04-27', this)">27</div><div class="cal-day" onclick="selectDate('2026-04-28', this)">28</div><div class="cal-day" onclick="selectDate('2026-04-29', this)">29</div><div class="cal-day" onclick="selectDate('2026-04-30', this)">30</div>
                                        </div>
                                    </div>
                                    <div class="calendar-month">
                                        <div class="cal-header">
                                            <div style="width: 24px;"></div>
                                            <div class="cal-title">May 2026</div>
                                            <span class="material-symbols-outlined cal-nav">chevron_right</span>
                                        </div>
                                        <div class="cal-grid">
                                            <div class="cal-day-name">S</div><div class="cal-day-name">M</div><div class="cal-day-name">T</div><div class="cal-day-name">W</div><div class="cal-day-name">T</div><div class="cal-day-name">F</div><div class="cal-day-name">S</div>
                                            <div></div><div></div><div></div><div></div><div></div><div class="cal-day" onclick="selectDate('2026-05-01', this)">1</div><div class="cal-day" onclick="selectDate('2026-05-02', this)">2</div>
                                            <div class="cal-day" onclick="selectDate('2026-05-03', this)">3</div><div class="cal-day" onclick="selectDate('2026-05-04', this)">4</div><div class="cal-day" onclick="selectDate('2026-05-05', this)">5</div><div class="cal-day" onclick="selectDate('2026-05-06', this)">6</div><div class="cal-day" onclick="selectDate('2026-05-07', this)">7</div><div class="cal-day" onclick="selectDate('2026-05-08', this)">8</div><div class="cal-day" onclick="selectDate('2026-05-09', this)">9</div>
                                            <div class="cal-day" onclick="selectDate('2026-05-10', this)">10</div><div class="cal-day" onclick="selectDate('2026-05-11', this)">11</div><div class="cal-day" onclick="selectDate('2026-05-12', this)">12</div><div class="cal-day" onclick="selectDate('2026-05-13', this)">13</div><div class="cal-day" onclick="selectDate('2026-05-14', this)">14</div><div class="cal-day" onclick="selectDate('2026-05-15', this)">15</div><div class="cal-day" onclick="selectDate('2026-05-16', this)">16</div>
                                            <div class="cal-day" onclick="selectDate('2026-05-17', this)">17</div><div class="cal-day" onclick="selectDate('2026-05-18', this)">18</div><div class="cal-day" onclick="selectDate('2026-05-19', this)">19</div><div class="cal-day" onclick="selectDate('2026-05-20', this)">20</div><div class="cal-day" onclick="selectDate('2026-05-21', this)">21</div><div class="cal-day" onclick="selectDate('2026-05-22', this)">22</div><div class="cal-day" onclick="selectDate('2026-05-23', this)">23</div>
                                            <div class="cal-day" onclick="selectDate('2026-05-24', this)">24</div><div class="cal-day" onclick="selectDate('2026-05-25', this)">25</div><div class="cal-day" onclick="selectDate('2026-05-26', this)">26</div><div class="cal-day" onclick="selectDate('2026-05-27', this)">27</div><div class="cal-day" onclick="selectDate('2026-05-28', this)">28</div><div class="cal-day" onclick="selectDate('2026-05-29', this)">29</div><div class="cal-day" onclick="selectDate('2026-05-30', this)">30</div>
                                            <div class="cal-day" onclick="selectDate('2026-05-31', this)">31</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="exact-dates-footer">
                                    <div class="exact-pill">Check in <span class="material-symbols-outlined" style="font-size:16px">keyboard_arrow_down</span></div>
                                </div>
                            </div>

                            <div id="tabFlexible" class="tab-content">
                                <div class="dropdown-title">How long would you like to stay?</div>
                                <div class="stay-pills">
                                    <div class="stay-pill active" onclick="selectPill(this)">Weekend</div>
                                    <div class="stay-pill" onclick="selectPill(this)">Week</div>
                                    <div class="stay-pill" onclick="selectPill(this)">Month</div>
                                </div>
                                
                                <div class="dropdown-title">When do you want to go?</div>
                                <div class="month-carousel">
                                    <div class="month-card" onclick="selectMonth('April', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">April</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                    <div class="month-card" onclick="selectMonth('May', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">May</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                    <div class="month-card" onclick="selectMonth('June', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">June</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                    <div class="month-card" onclick="selectMonth('July', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">July</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                    <div class="month-card" onclick="selectMonth('August', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">August</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                    <div class="month-card" onclick="selectMonth('September', '2026', this)">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                        <div class="m-name">September</div>
                                        <div class="m-year">2026</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="category-scroll">
        <div class="cat-chip active">
            <span class="material-symbols-outlined">pool</span> Amazing Pools
        </div>
        <div class="cat-chip">
            <span class="material-symbols-outlined">castle</span> Castles
        </div>
        <div class="cat-chip">
            <span class="material-symbols-outlined">landscape</span> Countryside
        </div>
        <div class="cat-chip">
            <span class="material-symbols-outlined">beach_access</span> Beachfront
        </div>
        <div class="cat-chip">
            <span class="material-symbols-outlined">cabin</span> Cabins
        </div>
        
        <a href="aichatbot.aspx" class="ai-chip">
            <span class="material-symbols-outlined">auto_awesome</span> Search with AI Assistant
        </a>
    </div>

    <div class="section-container">

        <div id="skeletonLoader">
            <div class="section-header">
                <div>
                    <div class="skeleton" style="height: 14px; width: 120px; margin-bottom: 12px; border-radius: 4px;"></div>
                    <div class="skeleton" style="height: 36px; width: 280px; border-radius: 6px;"></div>
                </div>
            </div>
            <div class="skeleton-wrapper">
                <div class="skeleton-card">
                    <div class="skeleton skel-img"></div>
                    <div class="skel-title-row"><div class="skeleton skel-title"></div><div class="skeleton skel-rating"></div></div>
                    <div class="skeleton skel-subtitle"></div>
                    <div class="skeleton skel-price"></div>
                </div>
                <div class="skeleton-card">
                    <div class="skeleton skel-img"></div>
                    <div class="skel-title-row"><div class="skeleton skel-title"></div><div class="skeleton skel-rating"></div></div>
                    <div class="skeleton skel-subtitle"></div>
                    <div class="skeleton skel-price"></div>
                </div>
                <div class="skeleton-card">
                    <div class="skeleton skel-img"></div>
                    <div class="skel-title-row"><div class="skeleton skel-title"></div><div class="skeleton skel-rating"></div></div>
                    <div class="skeleton skel-subtitle"></div>
                    <div class="skeleton skel-price"></div>
                </div>
                <div class="skeleton-card">
                    <div class="skeleton skel-img"></div>
                    <div class="skel-title-row"><div class="skeleton skel-title"></div><div class="skeleton skel-rating"></div></div>
                    <div class="skeleton skel-subtitle"></div>
                    <div class="skeleton skel-price"></div>
                </div>
            </div>
        </div>

        <div id="realContent" class="real-content-hidden">
            <div id="rowGuestFavorites" runat="server">
                <div class="section-header">
                    <div>
                        <div class="section-eyebrow">Curated selection</div>
                        <h2 class="section-title">Featured Sanctuaries</h2>
                    </div>
                </div>
                
                <asp:Repeater ID="rptGuestFavorites" runat="server">
                    <HeaderTemplate><div class="grid-wrapper"></HeaderTemplate>
                    <ItemTemplate><%# GetCardHtml(Container.DataItem) %></ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

            <div id="rowPool" runat="server" class="mt-20">
                <div class="section-header">
                    <div>
                        <div class="section-eyebrow">Dive in</div>
                        <h2 class="section-title">Poolside Escapes</h2>
                    </div>
                </div>
                <asp:Repeater ID="rptPool" runat="server">
                    <HeaderTemplate><div class="grid-wrapper"></HeaderTemplate>
                    <ItemTemplate><%# GetCardHtml(Container.DataItem) %></ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

            <div id="rowMidRange" runat="server" class="mt-20">
                <div class="section-header"><div><div class="section-eyebrow">Smart Choice</div><h2 class="section-title">Great Value</h2></div></div>
                <asp:Repeater ID="rptMidRange" runat="server">
                    <HeaderTemplate><div class="grid-wrapper"></HeaderTemplate>
                    <ItemTemplate><%# GetCardHtml(Container.DataItem) %></ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

            <div id="rowBudget" runat="server" class="mt-20">
                <div class="section-header"><div><div class="section-eyebrow">Wallet friendly</div><h2 class="section-title">Budget Escapes</h2></div></div>
                <asp:Repeater ID="rptBudget" runat="server">
                    <HeaderTemplate><div class="grid-wrapper"></HeaderTemplate>
                    <ItemTemplate><%# GetCardHtml(Container.DataItem) %></ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

            <div id="rowLuxury" runat="server" class="mt-20">
                <div class="section-header"><div><div class="section-eyebrow">Premium</div><h2 class="section-title">Luxury Stays</h2></div></div>
                <asp:Repeater ID="rptLuxury" runat="server">
                    <HeaderTemplate><div class="grid-wrapper"></HeaderTemplate>
                    <ItemTemplate><%# GetCardHtml(Container.DataItem) %></ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>
        </div>

    </div>

    <div class="cta-section">
        
        <div class="cta-card cta-host">
            <div class="cta-overlay"></div>
            <div class="cta-content">
                <h3 class="cta-title">Host your home</h3>
                <p class="cta-desc">Join our curated network of premium properties and earn more.</p>
                <a href="hostregistrationform.aspx" class="cta-btn cta-btn-white">Get Started</a>
            </div>
        </div>

        <div class="cta-card cta-login">
            <div class="cta-content">
                <h3 class="cta-title dark-text">Host Login</h3>
                <p class="cta-desc dark-text">Access your host dashboard to manage your properties and reservations effortlessly.</p>
                <div class="cta-btn-group">
                    <a href="hostloginform.aspx" class="cta-btn cta-btn-primary">Login Now</a>
                    <a href="#" class="cta-btn cta-btn-outline">Learn more</a>
                </div>
            </div>
        </div>

    </div>

    <asp:Label ID="lblNoResults" runat="server" Text="No approved properties found." Visible="false" style="text-align:center; display:block; padding:50px; font-weight:600;"></asp:Label>

    <script type="text/javascript">
        
        // --- JAVASCRIPT FOR THE AIRBNB DROPDOWN ---
        var whereSection = document.getElementById("whereSection");
        var whereDropdown = document.getElementById("whereDropdown");
        var whereInput = document.getElementById("whereInput");
        var ddlLocation = document.getElementById("<%= ddlLocation.ClientID %>");
        
        var whenSection = document.getElementById("whenSection");
        var dateDropdown = document.getElementById("dateDropdown");
        var txtWhen = document.getElementById("<%= txtWhen.ClientID %>");

        var tabDates = document.getElementById("tabDates");
        var tabFlexible = document.getElementById("tabFlexible");

        // --- NEW GUEST STEPPER LOGIC ---
        function updateGuests(change, event) {
            if (event) event.stopPropagation(); // Prevents clicking the buttons from triggering anything else

            var hiddenInput = document.getElementById("<%= txtGuestNo.ClientID %>");
            var display = document.getElementById("guestCountDisplay");

            // Parse current value or default to 1
            var current = parseInt(hiddenInput.value) || 1;
            var newVal = current + change;

            // Enforce minimum of 1 guest
            if (newVal >= 1) {
                hiddenInput.value = newVal;
                display.innerText = newVal;
            }
        }

        // 0. Build the Where dropdown dynamically from ASP.NET DropDownList
        if (ddlLocation && whereDropdown) {
            var subtitles = [
                "Guests also looked here",
                "For its seaside allure",
                "For nature lovers",
                "Great for summer getaways",
                "Near you",
                "A hidden gem",
                "Off the beaten path"
            ];
            var icons = ["location_city", "beach_access", "water_drop", "landscape", "nature", "cottage", "map"];

            var html = '';
            for (var i = 0; i < ddlLocation.options.length; i++) {
                var val = ddlLocation.options[i].value;
                var text = ddlLocation.options[i].text;

                // Skip the default placeholder if it exists (like "-- Select District --" or "0")
                if (val !== "0" && val !== "" && !text.includes("--")) {
                    var sub = subtitles[i % subtitles.length];
                    var iconClass = icons[i % icons.length];

                    html += '<div class="dropdown-item" data-value="' + val + '" data-index="' + i + '">' +
                        '<div class="item-icon"><span class="material-symbols-outlined">' + iconClass + '</span></div>' +
                        '<div class="item-text">' +
                        '<div class="item-title">' + text + '</div>' +
                        '<div class="item-subtitle">' + sub + '</div>' +
                        '</div>' +
                        '</div>';
                }
            }
            whereDropdown.innerHTML = html;
        }

        // Sync initial values if page reloads
        window.addEventListener('DOMContentLoaded', function () {
            // Sync Location
            if (ddlLocation && ddlLocation.value && ddlLocation.value !== "0") {
                var selectedText = ddlLocation.options[ddlLocation.selectedIndex].text;
                if (!selectedText.includes("--")) {
                    whereInput.value = selectedText;
                    whereInput.style.color = '#222222';
                }
            }

            // Sync Guest Number
            var hiddenGuestInput = document.getElementById("<%= txtGuestNo.ClientID %>");
            var guestDisplay = document.getElementById("guestCountDisplay");
            if (hiddenGuestInput && guestDisplay) {
                var val = parseInt(hiddenGuestInput.value) || 1;
                hiddenGuestInput.value = val;
                guestDisplay.innerText = val;
            }
        });

        // 1. Show the WHERE dropdown
        whereSection.addEventListener('click', function (e) {
            e.stopPropagation();

            // Close date dropdown if it's open
            dateDropdown.classList.remove("show");
            whenSection.classList.remove("active-section");

            var isShowing = whereDropdown.classList.contains("show");

            if (!isShowing) {
                whereDropdown.classList.add("show");
                whereSection.classList.add("active-section");
            } else {
                whereDropdown.classList.remove("show");
                whereSection.classList.remove("active-section");
            }
        });

        // 2. Show the WHEN dropdown
        whenSection.addEventListener('click', function (e) {
            e.stopPropagation();

            // Close where dropdown if it's open
            whereDropdown.classList.remove("show");
            whereSection.classList.remove("active-section");

            var isShowing = dateDropdown.classList.contains("show");

            if (!isShowing) {
                dateDropdown.classList.add("show");
                whenSection.classList.add("active-section");
            } else {
                dateDropdown.classList.remove("show");
                whenSection.classList.remove("active-section");
            }
        });

        // 3. Prevent clicks inside dropdowns from closing them
        whereDropdown.addEventListener('click', function (e) { e.stopPropagation(); });
        dateDropdown.addEventListener('click', function (e) { e.stopPropagation(); });

        // 4. Handle WHERE Item Selection (Using Event Delegation for dynamic items)
        whereDropdown.addEventListener('click', function (e) {
            var item = e.target.closest('.dropdown-item');
            if (!item) return; // Ignore clicks that aren't on an item

            e.stopPropagation();
            var text = item.querySelector('.item-title').innerText;
            var index = item.getAttribute('data-index');

            // Update visual input
            whereInput.value = text;
            whereInput.style.color = '#222222';

            // Synchronize with the hidden ASP.NET DropDownList
            if (ddlLocation) {
                ddlLocation.selectedIndex = index;
            }

            // Close the dropdown
            whereDropdown.classList.remove("show");
            whereSection.classList.remove("active-section");
        });

        // 5. Click anywhere else on the page to close both dropdowns
        document.addEventListener('click', function () {
            dateDropdown.classList.remove("show");
            whenSection.classList.remove("active-section");

            whereDropdown.classList.remove("show");
            whereSection.classList.remove("active-section");
        });

        // 6. Tab Switching (Dates vs Flexible)
        function switchTab(tab) {
            var tabs = document.querySelectorAll('.date-tab');
            tabs.forEach(t => t.classList.remove('active'));

            if (tab === 'dates') {
                tabs[0].classList.add('active');
                tabDates.classList.add('active');
                tabFlexible.classList.remove('active');
            } else {
                tabs[1].classList.add('active');
                tabFlexible.classList.add('active');
                tabDates.classList.remove('active');
            }
        }

        // 7. Handle Calendar Date Selection
        function selectDate(dateString, element) {
            // Remove active states
            document.querySelectorAll('.cal-day').forEach(function (el) {
                el.classList.remove('selected');
            });
            // Highlight chosen day
            element.classList.add('selected');

            // Set the ASP.NET Textbox value
            txtWhen.value = dateString;

            setTimeout(function () {
                dateDropdown.classList.remove("show");
                whenSection.classList.remove("active-section");
            }, 300);
        }

        // 8. Handle Flexible Pill selection
        function selectPill(element) {
            document.querySelectorAll('.stay-pill').forEach(function (el) {
                el.classList.remove('active');
            });
            element.classList.add('active');
        }

        // 9. Handle Flexible Month Selection
        function selectMonth(monthName, year, element) {
            document.querySelectorAll('.month-card').forEach(function (el) {
                el.classList.remove('active');
            });

            element.classList.add('active');
            txtWhen.value = monthName + " " + year;

            setTimeout(function () {
                dateDropdown.classList.remove("show");
                whenSection.classList.remove("active-section");
            }, 300);
        }

        // Sticky Search Bar Scroll Logic
        window.addEventListener('scroll', function () {
            var searchBar = document.getElementById("mainSearchBar");
            if (window.scrollY > 450) {
                searchBar.classList.add("sticky");
            } else {
                searchBar.classList.remove("sticky");

                // Optional: auto-close dropdowns when turning sticky off/on to prevent visual bugs
                dateDropdown.classList.remove("show");
                whenSection.classList.remove("active-section");
                whereDropdown.classList.remove("show");
                whereSection.classList.remove("active-section");
            }
        });

        // --- SKELETON REVEAL LOGIC ---
        window.addEventListener('load', function () {
            var skeleton = document.getElementById('skeletonLoader');
            var realContent = document.getElementById('realContent');

            if (skeleton && realContent) {
                setTimeout(function () {
                    skeleton.style.display = 'none';
                    realContent.classList.remove('real-content-hidden');

                    realContent.style.animation = 'fadeInPop 0.4s ease-out';
                }, 500);
            }
        });
    </script>
</asp:Content>

<script runat="server">
    protected string GetCardHtml(object dataItem) {
        System.Data.DataRowView row = (System.Data.DataRowView)dataItem;
        
        // FIX: Evaluates the pimage path directly as a string instead of trying to convert it from a byte array
        string img = row["pimage"] != DBNull.Value && !string.IsNullOrEmpty(row["pimage"].ToString()) 
            ? ResolveUrl("~/" + row["pimage"].ToString()) 
            : "https://via.placeholder.com/600x600?text=Housie+Stay";
        
        return string.Format(@"
            <a href='customerpropertydetail.aspx?pid={0}' class='property-card'>
                <div class='img-container'>
                    <img src='{1}' class='prop-img' loading='lazy' />
                    <button class='fav-btn' onclick='event.preventDefault();'>
                        <span class='material-symbols-outlined'>favorite</span>
                    </button>
                </div>
                <div class='card-body'>
                    <div class='card-top-row'>
                        <div class='card-title'>{2}</div>
                        <div class='card-rating'>
                            <span class='material-symbols-outlined'>star</span> New
                        </div>
                    </div>
                    <div class='card-subtitle'>{3}</div>
                    <div class='card-price'>
                        &#8377;{4:N0} <span>/ night</span>
                    </div>
                </div>
            </a>", 
            row["pid"], img, row["title"], row["district"], Convert.ToDouble(row["price"]));
    }
</script>