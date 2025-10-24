# GPIO UVC Specifications

The **GPIO UVC interface** implements a generic 32-bit bus that allows users to
connect it to any DUT port up to 32 bits wide and generate randomized stimulus.
By indexing the interface, it can also be connected to single-bit ports (e.g.
reset) or to narrower buses such as 8-bit interfaces by mapping only the least
significant bits.


## Configuration Object

The **GPIO UVC agent configuration object** should include the following members:

- **`gpio_width`**  
  Defines the width of the target bus that the user is connecting to.  
  This parameter is used to:
  - Generate a masking function to normalize undefined bits during monitoring.  
  - Constrain `sequence_item` members to produce valid randomized data.

- **`start_value`**  
  Specifies the default value that the UVC must drive on the port at the beginning of the simulation.


## Sequence Item

The **GPIO UVC `sequence_item`** should contain the following members:

- `rand gpio_uvc_data_t m_gpio_pin` — random data to be driven.  
- `rand gpio_uvc_type_e m_trans_type` — transaction type: synchronous or asynchronous.  
- `rand gpio_uvc_delay_enable_e m_delay_enable` — enables or disables inter-transaction delay.  
- `rand int unsigned m_delay_duration_ps` — delay duration in picoseconds (for asynchronous mode when delay is enabled).  
- `rand int unsigned m_delay_cycles` — number of delay cycles (for synchronous mode when delay is enabled).  
- `rand gpio_uvc_align_type_e m_align_type` — defines alignment type:  
  - For **synchronous mode**, selects whether the transaction aligns to the rising or falling clock edge.  
  - For **asynchronous mode**, may include a *no-align* option.

> **Note:**  
> The `m_align_type` parameter determines both the initial alignment and the termination of synchronous transactions.  
> - If a transaction aligns with the **rising edge**, it should end on the **falling edge**.  
> - If it aligns with the **falling edge**, it should end on the **rising edge**.  
>  
> This design choice ensures clear transaction separation and avoids race conditions.

For `m_delay_enable`, `m_trans_type`, and `m_align_type`, it is recommended to use `typedef enum` definitions for improved readability and maintainability.

## Implementation Guidelines

Use the diagram below as reference and implement the corresponding **driver** and **monitor** logic.

Then, create a **sequence library** including:

- A sequence that drives *N* randomized values aligned to the **rising edge** of the clock.  
- A sequence that emulates a **pulse**, specifying **assert** and **de-assert** durations.  
- A sequence that reads and drives values from an **input text file**.
