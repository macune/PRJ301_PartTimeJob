// assets/js/profile.js
function previewAvatar(url) {
    const img = document.getElementById('avatarPreview');
    const username = document.getElementById('accountUsername').value || 'User';
    
    if (url && url.startsWith('http')) {
        img.src = url;
        img.onerror = () => {
            img.src = `https://ui-avatars.com/api/?name=${username}&background=2e7d32&color=fff&size=130`;
        };
    } else {
        img.src = `https://ui-avatars.com/api/?name=${username}&background=2e7d32&color=fff&size=130`;
    }
}
function previewLogo(url) {
    const img = document.getElementById('logoPreview');
    const username = document.getElementById('accountUsername').value || 'B';
    
    if (url && url.startsWith('http')) {
        img.src = url;
        img.onerror = () => {
            img.src = `https://ui-avatars.com/api/?name=${username.charAt(0)}&background=087990&color=fff&size=130&bold=true`;
        };
    } else {
        img.src = `https://ui-avatars.com/api/?name=${username.charAt(0)}&background=087990&color=fff&size=130&bold=true`;
    }
}


