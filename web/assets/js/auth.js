function togglePassword(fieldId, btn) {
    const field = document.getElementById(fieldId);
    const icon = btn.querySelector('i');
    if (field.type === 'password') {
        field.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        field.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

function checkStrength(val) {
    const bar  = document.getElementById('strengthBar');
    const text = document.getElementById('strengthText');
    if(!bar || !text) return;

    let strength = 0;
    if (val.length >= 6)  strength++;
    if (val.length >= 10) strength++;
    if (/[A-Z]/.test(val) && /[0-9]/.test(val)) strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;

    const levels = [
        { w: '0%',   color: '',          label: '' },
        { w: '33%',  color: '#dc3545',   label: '<span class="text-danger">Yếu</span>' },
        { w: '66%',  color: '#ffc107',   label: '<span class="text-warning">Trung bình</span>' },
        { w: '100%', color: '#198754',   label: '<span class="text-success">Mạnh</span>' },
    ];
    
    const lvl = Math.min(strength, 3);
    bar.style.width           = levels[lvl].w;
    bar.style.backgroundColor = levels[lvl].color;
    text.innerHTML            = lvl > 0 ? 'Độ mạnh: ' + levels[lvl].label : '';
}