// =========================================================================
// XỬ LÝ DROPDOWN TỈNH/THÀNH - XÃ/PHƯỜNG TỪ FILE JSON CỤC BỘ (BỘ MÁY MỚI 2026)
// =========================================================================

document.addEventListener("DOMContentLoaded", function() {
    const citySelect = document.getElementById('city');
    const wardSelect = document.getElementById('ward');
    
    const selectedCity = citySelect.getAttribute('data-selected');
    const selectedWard = wardSelect.getAttribute('data-selected');

    // Tự động tính toán Context Path để tránh lỗi đường dẫn khi chạy server
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
    const jsonUrl = (contextPath.length > 1 ? contextPath : '') + '/assets/data/locations.json';

    // Đọc dữ liệu từ file JSON cục bộ
    fetch(jsonUrl)
        .then(response => response.json())
        .then(data => {
            data.forEach(province => {
                let option = document.createElement('option');
                option.text = province.name;
                option.value = province.name; 
                
                // Lưu danh sách Xã/Phường trực tiếp vào bộ nhớ của thẻ option
                option.dataset.wards = JSON.stringify(province.wards); 
                
                if(province.name === selectedCity) {
                    option.selected = true;
                }
                citySelect.add(option);
            });

            // Nếu trang chủ đang có bộ lọc Tỉnh/Thành cũ, tự động gọi hiển thị Xã/Phường tương ứng
            if(selectedCity) {
                loadWards(citySelect.options[citySelect.selectedIndex]);
            }
        })
        .catch(error => console.error('Lỗi khi đọc file locations.json:', error));

    // Bắt sự kiện khi người dùng thay đổi lựa chọn Tỉnh/Thành
    citySelect.addEventListener('change', function() {
        wardSelect.innerHTML = '<option value="">Chọn Xã/Phường</option>'; 
        if (this.selectedIndex > 0) {
            loadWards(this.options[this.selectedIndex]);
        }
    });

    // Hàm bổ trợ tải danh sách Xã/Phường lên giao diện
    function loadWards(selectedOption) {
        wardSelect.innerHTML = '<option value="">Chọn Xã/Phường</option>'; 
        if(!selectedOption.dataset.wards) return;
        
        let wards = JSON.parse(selectedOption.dataset.wards);
        wards.forEach(wardName => {
            let option = document.createElement('option');
            option.text = wardName;
            option.value = wardName;
            
            if(wardName === selectedWard) {
                option.selected = true;
            }
            wardSelect.add(option);
        });
    }
});