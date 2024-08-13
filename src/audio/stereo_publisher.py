import rclpy
from rclpy.node import Node
from std_msgs.msg import Int16MultiArray
import sounddevice as sd
import numpy as np

class AudioPublisher(Node):

    def __init__(self, device_index):
        super().__init__('audio_publisher')
        self.publisher_ = self.create_publisher(Int16MultiArray, 'audio', 10)
        self.channels = 2  # Changed to 2 channels for stereo
        self.rate = 16000
        self.chunk = 2048  # Increased chunk size to reduce overflow risk
        self.device_index = device_index
        self.is_shutting_down = False
        self.stream = sd.InputStream(samplerate=self.rate, 
                                     channels=self.channels, 
                                     blocksize=self.chunk,
                                     device=self.device_index, 
                                     dtype='int16',  # Ensuring data type is int16
                                     callback=self.audio_callback)
        self.stream.start()

    def audio_callback(self, indata, frames, time, status):
        if status:
            self.get_logger().error(f'Status: {str(status)}')
        if not self.is_shutting_down:
            audio_data = indata.flatten()  # Flatten to 1D array
            msg = Int16MultiArray()
            msg.data = audio_data.tolist()
            self.publisher_.publish(msg)
            self.get_logger().info(f'Publishing audio data: {len(audio_data)} samples')

    def destroy_node(self):
        self.is_shutting_down = True
        super().destroy_node()
        self.stream.stop()
        self.stream.close()

def main(args=None):
    rclpy.init(args=args)

    # Using device index 7 for HyperX QuadCast S
    device_index = 7

    audio_publisher = AudioPublisher(device_index)

    try:
        rclpy.spin(audio_publisher)
    except KeyboardInterrupt:
        pass
    finally:
        audio_publisher.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
