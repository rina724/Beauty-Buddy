// app/javascript/cosmetics_selector.js

document.addEventListener('turbo:load', () => {
  console.log('Cosmetics selector script loaded');
  
  // モーダル関連の処理をここに移動
  const modalButton = document.querySelector('button[onclick="window.my_modal_3.showModal()"]');
  const modal = document.getElementById('my_modal_3');
  const closeButton = modal.querySelector('form[method="dialog"] button');

  if (modalButton) {
    modalButton.addEventListener('click', () => {
      modal.showModal();
    });
  }

  if (closeButton) {
    closeButton.addEventListener('click', () => {
      modal.close();
    });
  }
});

// グローバルスコープに関数を定義
window.addSelectedCosmetics = function() {
  const select = document.getElementById('cosmetic-select');
  const selectedOptions = Array.from(select.selectedOptions);
  const selectedCosmeticsDiv = document.getElementById('selected-cosmetics');

  selectedOptions.forEach((option) => {
    const cosmeticId = option.value;
    const cosmeticName = option.text;

    if (!document.getElementById(`cosmetic-${cosmeticId}`)) {
      const newButton = document.createElement('button');
      newButton.id = `cosmetic-${cosmeticId}`;
      newButton.className = 'btn btn-sm btn-outline max-w-full h-12';
      newButton.innerHTML = `
        ${cosmeticName}
        <input type="hidden" name="daily_report[daily_report_cosmetics_attributes][][mycosmetic_id]" value="${cosmeticId}">
      `;
      newButton.onclick = () => window.removeCosmeticField(cosmeticId);
      selectedCosmeticsDiv.appendChild(newButton);
    }
  });

  select.selectedIndex = -1; // Reset selection
  window.my_modal_3.close();
};

window.removeCosmeticField = function(cosmeticId) {
  const field = document.getElementById(`cosmetic-${cosmeticId}`);
  if (field) {
    field.remove();
  }
};