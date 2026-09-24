import { Controller } from "@hotwired/stimulus"

// Adds and removes invoice lines without a full page reload.
export default class extends Controller {
  static targets = ["list", "template", "destroy"]

  add(event) {
    event.preventDefault()

    const template = this.templateTarget.innerHTML
    const wrapper = document.createElement("div")
    wrapper.innerHTML = template.trim()
    const lineItem = wrapper.firstElementChild
    const index = this.nextIndex()

    this.replaceIndex(lineItem, index)
    this.listTarget.appendChild(lineItem)
  }

  remove(event) {
    event.preventDefault()

    const lineItem = event.target.closest("[data-line-item]")
    if (!lineItem) return

    const destroyField = lineItem.querySelector("[data-line-items-target='destroy']")
    if (destroyField) {
      destroyField.checked = true
      lineItem.hidden = true
    } else {
      lineItem.remove()
    }
  }

  nextIndex() {
    return this.listTarget.querySelectorAll("[data-line-item]").length
  }

  replaceIndex(element, index) {
    element.querySelectorAll("[name], [id], [for]").forEach((field) => {
      for (const attribute of ["name", "id", "for"]) {
        const value = field.getAttribute(attribute)
        if (value?.includes("__INDEX__")) {
          field.setAttribute(attribute, value.replaceAll("__INDEX__", index))
        }
      }
    })
  }
}
