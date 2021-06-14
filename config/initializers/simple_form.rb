# Use this setup block to configure all options available in SimpleForm.
class SimpleForm::Inputs::SelectBoxInput < SimpleForm::Inputs::CollectionSelectInput
end
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.
  config.wrappers :default, class: 'control',
    hint_class: :field_with_hint, error_class: :field_with_errors do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label
    b.use :input, class: 'input'
    b.use :hint,  wrap_with: { tag: :span, class: 'help is-info' }
    b.use :error, wrap_with: { tag: :span, class: 'help is-danger' }
  end
  config.wrappers :bulma_text, class: 'control' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly

    b.use :label
    b.use :input, class: 'textarea'
    b.use :hint,  wrap_with: { tag: :span, class: 'help is-info' }
    b.use :error, wrap_with: { tag: :span, class: 'help is-danger' }
  end
  config.wrappers :bulma_select, tag: :div, class: 'control' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, wrap_with: { tag: :div, class: 'select' }
    b.use :hint,  wrap_with: { tag: :span, class: 'help is-info' }
    b.use :error, wrap_with: { tag: :span, class: 'help is-danger' }
  end
  config.wrappers :bulma_checkbox, tag: :div, class: "control"  do |b|
    b.use :html5
    b.wrapper tag: :label, class: 'checkbox' do |ba|
      ba.use :input
      ba.use :label_text 
    end
    b.use :hint,  wrap_with: { tag: :span, class: "help is-info" }
    b.use :error, wrap_with: { tag: :span, class: "help is-danger" }
  end
  config.wrappers :bulma_checkbox_list, tag: :div, class: "control"  do |b|
    b.use :html5
    b.use :label
    b.use :input, wrap_with: { tag: :div, class: 'checkbox-list' }
    b.use :hint,  wrap_with: { tag: :span, class: "help is-info" }
    b.use :error, wrap_with: { tag: :span, class: "help is-danger" }
  end

  config.wrapper_mappings = {
    text: :bulma_text,
    select_box: :bulma_select,
    check_boxes: :bulma_checkbox_list,
    boolean: :bulma_checkbox
  }

  config.default_wrapper = :default
  config.boolean_style = :inline
  config.button_class = 'button'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # Use :to_sentence to list all errors for each field.
  # config.error_method = :first

  config.error_notification_tag = :div
  config.error_notification_class = 'error_notification'
  config.label_class = :label
  config.browser_validations = false


  # Default class for inputs
  config.input_class = nil

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'checkbox'
end
